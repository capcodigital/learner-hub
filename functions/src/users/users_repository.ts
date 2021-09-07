/* eslint-disable require-jsdoc */
import * as admin from 'firebase-admin';
import { logger } from 'firebase-functions/v1';

const TABLE_USERS = "users"

export async function insertUser(user: User) {
    const db = admin.firestore();
    const collection = db.collection(TABLE_USERS);
    collection.where("uid", "==", user.uid).get()
        .then(async (snap) => {
            if (snap.empty) {
                collection.doc(user.uid.toString()).create({ user });
            } else {
                throw Error("User already exists");
            }
        });
}

export async function editUser(
    userId: string,
    property: any
) {
    //const propName = property["name"];
    const propValue = property["value"];
    const db = admin.firestore();
    const collection = db.collection(TABLE_USERS);
    collection.where("id", "==", userId).get()
        .then(async (snap) => {
            if (snap.empty) {
                throw Error("User not found!");
            } else if (snap.size > 1) {
                throw Error("More that 1 Users found!");
            } else
                snap.forEach(it => {
                    collection.doc(it.id).update({
                        'propName': propValue
                    })
                })
        });
}

export async function getAllUsers(): Promise<User[]> {
    try {
        const snapshot = await admin.firestore()
            .collection(TABLE_USERS).get();
        return toUsers(snapshot);
    } catch (exception) {
        logger.log(exception)
        throw exception;
    }
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