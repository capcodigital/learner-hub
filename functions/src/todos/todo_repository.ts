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

export async function insert(todo: TODO): Promise<any[]> {
    const col = admin.firestore().collection(TABLE_TODOS);
    var todoToReturn: any = {};
    await col.add({ 
        userId: todo.userId,
        title: todo.title,
        content: todo.content,
        isCompleted: todo.isCompleted }).then(function(docRef) {
            todoToReturn = {
                    id: docRef.id,
                    userId: todo.userId,
                    title: todo.title,
                    content: todo.content,
                    isCompleted: todo.isCompleted
                };
        });
        if (todoToReturn == null) { throw new TODONotFoundError(); }
        return todoToReturn;
}

export async function update(
    todoId: string,
    todo: TODO
): Promise<any[]> {
    const doc = admin.firestore().collection(TABLE_TODOS).doc(todoId);
    const docRef = await doc.get();
    var todoToReturn: any = {};
    if (docRef.exists) {
        const item = docRef.data() as TODO;
        if (todo.userId == item.userId) {
            await doc.update({
                userId: todo.userId,
                title: todo.title,
                content: todo.content,
                isCompleted: todo.isCompleted
            }).then(function() {
                todoToReturn = {
                id: docRef.id,
                userId: todo.userId,
                title: todo.title,
                content: todo.content,
                isCompleted: todo.isCompleted
            }});
            return todoToReturn;
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
        const item = docRef.data();
        if (item == null) { throw new TODONotFoundError('TODO cannot be found'); }
        else if (uid == item.userId) doc.delete();
        else throw new AccessForbidenError("TODO is not of current user");
    }
    else throw new TODONotFoundError();
}

async function toTODOs(snap: FirebaseFirestore.QuerySnapshot): Promise<any[]> {
    const items = Array<any>();
    if (!snap.empty) {
        snap.forEach(docRef => {
            const it = docRef.data();
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
