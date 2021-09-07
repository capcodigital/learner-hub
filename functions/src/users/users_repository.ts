/* eslint-disable require-jsdoc */
import * as admin from 'firebase-admin';
import { logger } from 'firebase-functions/v1';

const TABLE_USERS = "Users"

export async function insertUser(user: User) {
    const db = admin.firestore();
    const collection = db.collection(TABLE_USERS);
    collection.where("uid", "==", user.uid).get()
        .then(async (snap) => {
            if (snap.empty) {
                collection.doc(user.uid.toString()).create({
                    uid: user.uid,
                    email: user.email,
                    password: user.password,
                    firstName: user.firstName,
                    surname: user.surname,
                    jobTitle: user.jobTitle,
                    bio: user.bio,
                    confluenceConnected: user.confluenceConnected
                });
            } else {
                throw Error("User already exists");
            }
        });
}

export function editUser(
    uid: string,
    property: any
) {
    logger.log(uid);
    const key = property["key"];
    const value = property["value"];
    logger.log(key);
    logger.log(value);
    const db = admin.firestore();
    const collection = db.collection(TABLE_USERS);
    collection.doc(uid).update({
        [key]: value
    })
}

export async function getAllUsers(): Promise<User[]> {
    const snapshot = await admin.firestore()
        .collection(TABLE_USERS).get();
    return toUsers(snapshot);
}

async function toUsers(snapshot: FirebaseFirestore.QuerySnapshot):
    Promise<User[]> {
    const users = Array<User>();
    if (!snapshot.empty) {
        snapshot.forEach((doc: { data: () => any }) => {
            users.push(doc.data());
        });
    }
    return users;
}