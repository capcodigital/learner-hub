/* eslint-disable require-jsdoc */
import * as admin from 'firebase-admin';

const TABLE_USERS = "Users";

export class UserFirestoreError extends Error { }
export class UserExistsError extends UserFirestoreError { }
export class UserNotFoundError extends UserFirestoreError { }

export async function insertUser(
    docId: string,
    user: User,
) {
    const db = admin.firestore();
    const collection = db.collection(TABLE_USERS);
    const doc = await collection.doc(docId).get();
    if (!doc.exists) {
        collection.doc(docId).create({
            name: user.name,
            lastName: user.lastName,
            email: user.email,
            jobTitle: user.jobTitle,
            bio: user.bio,
            skills: user.skills
        });
    } else {
        throw new UserExistsError();
    }
}

export async function editUser(user: any) {
    const col = admin.firestore().collection(TABLE_USERS);
    const snapshot = await admin.firestore()
        .collection(TABLE_USERS)
        .where("email", "==", user["email"])
        .get();
    if (!snapshot.empty) {
        snapshot.forEach((doc => {
            col.doc(doc.id).update(user);
        }));
    } else {
        throw new UserNotFoundError();
    }
}

export async function getAllUsers(): Promise<any[]> {
    const snapshot = await admin.firestore()
        .collection(TABLE_USERS).get();
    return toUsers(snapshot);
}

async function toUsers(snapshot: FirebaseFirestore.QuerySnapshot):
    Promise<any[]> {
    const users = Array<any>();
    if (!snapshot.empty) {
        snapshot.forEach((doc: { data: () => any }) => {
            var item = doc.data() as User
            users.push({
                name: item.name,
                lastName: item.lastName,
                email: item.email,
                jobTitle: item.jobTitle,
                bio: item.bio,
                skills: item.skills
            });
        });
    }
    return users;
}