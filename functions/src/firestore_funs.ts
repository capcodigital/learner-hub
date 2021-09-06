/* eslint-disable require-jsdoc */
import * as admin from 'firebase-admin';
import { logger } from 'firebase-functions/v1';
// If skip firebase auth for quick test, then following line is needed
// admin.initializeApp();

const TABLE_CERTIFICATIONS = "certifications"
const TABLE_USERS = "users"

export async function save(items: Array<Certification>) {
    const db = admin.firestore();
    const collection = db.collection(TABLE_CERTIFICATIONS);
    items.forEach((item) => {
        collection
            .where("username", "==", filter(item.username))
            .where("title", "==", filter(item.title))
            .get()
            .then(async (snap) => {
                if (snap.empty) {
                    // If item not exist, create it
                    collection.doc().create({
                        username: item.username,
                        platform: item.platform,
                        title: item.title,
                        category: item.category,
                        subcategory: item.subcategory,
                        date: item.date,
                        description: item.description,
                        rating: item.rating,
                    });
                } else {
                    // If item exists, udpate fields
                    snap.forEach(it => {
                        collection.doc(it.id).update({
                            platform: item.platform,
                            category: item.category,
                            subcategory: item.subcategory,
                            date: item.date,
                        })
                    })
                }
            });
    });
}

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

export async function getFromFirestoreByPlatformAsList(platform: string
): Promise<Certification[]> {
    try {
        const snapshot = await admin.firestore()
            .collection(TABLE_CERTIFICATIONS)
            .where("platform", "==", platform)
            .get();
        return toCertifications(snapshot);
    } catch (e) {
        logger.log(e)
        throw e;
    }
}

export async function getFromFirestoreByCategoryAsList(
    category: string,
    subcategory: string
): Promise<Certification[]> {
    try {
        const snapshot = await getSnapshotForCategory(category, subcategory);
        return toCertifications(snapshot);
    } catch (e) {
        logger.log(e)
        throw e;
    }
}

export async function getUserCertifications(username: string): Promise<Certification[]> {
    try {
        logger.log("GETTING USER CERTIFICATIONS");
        const snapshot = await admin.firestore()
            .collection("certifications")
            .where("name", "==", username)
            .get();
        return toCertifications(snapshot);
    } catch (exception) {
        logger.log(exception)
        throw exception;
    }
}

export async function updateDescription(
    title: string,
    desc: string
) {
    const col = admin.firestore().collection(TABLE_CERTIFICATIONS)
    await col.where('title', '==', title)
        .get()
        .then(snapshot => {
            if (!snapshot.empty) {
                snapshot.forEach(item => {
                    col.doc(item.id).update({ description: desc })
                })
            }
        })
}

export async function updateRating(
    certId: string,
    rating: number
) {
    await admin.firestore().collection(TABLE_CERTIFICATIONS)
        .doc(certId).update({ rating: rating })
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

async function getSnapshotForCategory(
    category: string,
    subcategory: string
): Promise<FirebaseFirestore.QuerySnapshot> {
    try {
        var snapshot = null;
        if (category != null && subcategory != null) {
            snapshot = await admin.firestore()
                .collection(TABLE_CERTIFICATIONS)
                .where("category", "==", category)
                .where("subcategory", "==", subcategory)
                .get();
        } else if (category != null) {
            snapshot = await admin.firestore()
                .collection(TABLE_CERTIFICATIONS)
                .where("category", "==", category)
                .get();
        } else if (subcategory != null) {
            snapshot = await admin.firestore()
                .collection(TABLE_CERTIFICATIONS)
                .where("subcategory", "==", subcategory)
                .get();
        } else {
            snapshot = await admin.firestore()
                .collection(TABLE_CERTIFICATIONS)
                .get();
        }
        logger.log(snapshot.size);
        return snapshot;
    } catch (e) {
        logger.log(e)
        throw e;
    }
}

async function toCertifications(snapshot: FirebaseFirestore.QuerySnapshot):
    Promise<Certification[]> {
    const results = Array<Certification>();
    if (!snapshot.empty) {
        snapshot.forEach((doc: { data: () => any }) => {
            results.push(doc.data());
        });
    }
    return results;
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

function filter(text: string): string {
    return text != null ? text : "";
}
