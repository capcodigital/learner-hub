/* eslint-disable require-jsdoc */
import * as admin from 'firebase-admin';

const TABLE_TODOS = "TODOs";

export class TODOFirestoreError extends Error { }
export class TODOExistsError extends TODOFirestoreError { }
export class TODONotFoundError extends TODOFirestoreError { }
export class AccessForbidenError extends TODOFirestoreError { }

export async function getUserTODOs(uid: string): Promise<any[]> {
    const collection = admin.firestore().collection(TABLE_TODOS);
    const snap = await collection.where("userId", "==", uid).get();
    return toTODOs(snap);
}

export async function insert(
    uid: string,
    item: any,
) {
    const col = admin.firestore().collection(TABLE_TODOS);

    const title = item["title"];
    const content = item["content"];
    const isCompleted = item["isCompleted"];

    const docRef = await col.add({
        userId: uid,
        title: title,
        content: content,
        isCompleted: isCompleted
    });

    return {
        id: docRef.id,
        userId: uid,
        title: title,
        content: content,
        isCompleted: isCompleted
    }
}

export async function update(
    uid: string,
    todoId: string,
    todo: any
) {
    const doc = admin.firestore().collection(TABLE_TODOS).doc(todoId);
    const docRef = await doc.get();
    if (docRef.exists) {
        const item = docRef.data() as TODO;
        if (uid == item.userId) {
            doc.update(todo);
            const updated = docRef.data() as TODO;
            return {
                id: docRef.id,
                userId: updated.userId,
                title: updated.title,
                content: updated.content,
                isCompleted: updated.isCompleted
            }
        } else throw new AccessForbidenError("TODO is not of current user");
    } else throw new TODONotFoundError();
}

// "delete" is a reserved word
export async function deleteItem(
    uid: string,
    todoId: string
) {
    const doc = admin.firestore().collection(TABLE_TODOS).doc(todoId);
    const docRef = await doc.get();
    if (docRef.exists) {
        const item = docRef.data() as TODO;
        if (uid == item.userId) doc.delete();
        else throw new AccessForbidenError("TODO is not of current user");
    }
    else throw new TODONotFoundError();
}

async function toTODOs(snap: FirebaseFirestore.QuerySnapshot): Promise<any[]> {
    const items = Array<any>();
    if (!snap.empty) {
        snap.forEach(docRef => {
            const it = docRef.data() as TODO;
            items.push({
                id: docRef.id,
                userId: it.userId,
                title: it.title,
                content: it.content,
                isCompleted: it.isCompleted
            });
        });
    }
    return items;
}
