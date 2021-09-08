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
                collection.doc(user.uid).create({
                    uid: user.uid,
                    email: user.email,
                    firstName: user.firstName,
                    surname: user.surname,
                    jobTitle: user.jobTitle,
                    bio: user.bio,
                    confluenceConnected: user.confluenceConnected,
                    skills: user.skills
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
    collection
        .get()
        .then(async (snap) => {
            snap.forEach(it => {
                collection.doc(it.id).update({
                    [key]: value
                });
            });
        });
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