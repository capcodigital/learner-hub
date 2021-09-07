/* eslint-disable require-jsdoc */
import * as admin from 'firebase-admin';
import { logger } from 'firebase-functions/v1';

const TABLE_USERS = "users"

export async function insertUser(user: User) {
    const db = admin.firestore();
    const collection = db.collection(TABLE_USERS);
    collection.where("id", "==", user.id).get()
        .then(async (snap) => {
            if (snap.empty) {
                collection.doc(user.id.toString()).create({
                    id: user.id,
                    firstName: user.firstName,
                    surname: user.surname,
                    jobTitle: user.jobTitle,
                    confluenceConnected: user.confluenceConnected,
                    bio: user.bio,
                    email: user.email,
                    passwordHash: user.passwordHash
                });
            } else {
                throw Error("User already exists");
            }
        });
}

export async function editUser(
    userId: number,
    property: any
) {
    const db = admin.firestore();
    const collection = db.collection(TABLE_USERS);
    collection.where("id", "==", userId).get()
        .then(async (snap) => {
            if (snap.empty) {
                logger.log("user not found!");
            } else if (snap.size > 1) {
                logger.log("more than one users found!");
            } else
                snap.forEach(it => {
                    collection.doc(it.id).update({
                        property: property['value']
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