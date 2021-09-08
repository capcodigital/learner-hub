/* eslint-disable require-jsdoc */
import * as admin from 'firebase-admin';

const TABLE_USERS = "Users"

export async function insertUser(
    docId: string,
    user: User,
) {
    const db = admin.firestore();
    const collection = db.collection(TABLE_USERS);
    const doc = await collection.doc(docId).get();
    if (!doc.exists) {
        collection.doc(docId).create({
            email: user.email,
            firstName: user.firstName,
            surname: user.surname,
            jobTitle: user.jobTitle,
            bio: user.bio,
            confluenceConnected: user.confluenceConnected,
            skills: user.skills
        });
    } else {
        throw Error("User already exists!");
    }
}


export async function editUser(
    uid: string,
    property: any
) {
    const key = property["key"];
    const value = property["value"];
    const db = admin.firestore();
    const collection = db.collection(TABLE_USERS);
    const doc = await collection.doc(uid).get();
    if (doc.exists) {
        collection.doc(uid).update({
            [key]: value
        });
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
                email: item.email,
                firstName: item.firstName,
                surname: item.surname,
                jobTitle: item.jobTitle,
                bio: item.bio,
                confluenceConnected: item.confluenceConnected
            });
        });
    }
    return users;
}