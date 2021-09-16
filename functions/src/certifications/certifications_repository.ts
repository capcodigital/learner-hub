/* eslint-disable require-jsdoc */
import * as admin from 'firebase-admin';
import { logger } from 'firebase-functions/v1';

const TABLE_CERTIFICATIONS = "Certifications";

export async function save(items: Array<Certification>) {
    const db = admin.firestore();
    const collection = db.collection(TABLE_CERTIFICATIONS);
    items.forEach((item) => {
        // If item is missing username or title, it cannot be 
        // uniquely identified. So we just save it. 
        if (item.username == undefined || item.title == undefined) {
            addItem(collection, item);
        } else {
            // Item has username & title, so it can be uniquely identified.
            // We will first check if it already exists.
            collection
                .where("username", "==", item.username)
                .where("title", "==", item.title)
                .get()
                .then(async (snap) => {
                    if (snap.empty) {
                        addItem(collection, item);
                    } else {
                        // If item exists, udpate fields
                        snap.forEach(it => {
                            collection.doc(it.id).update({
                                platform: filter(item.platform),
                                category: filter(item.category),
                                subcategory: filter(item.subcategory),
                                date: filter(item.date),
                            })
                        })
                    }
                });
        }
    });
}

function addItem(
    collection: FirebaseFirestore.CollectionReference,
    item: Certification
) {
    collection.doc().create({
        username: filter(item.username),
        platform: filter(item.platform),
        title: filter(item.title),
        category: filter(item.category),
        subcategory: filter(item.subcategory),
        date: filter(item.date),
        description: filter(item.description),
        rating: item.rating,
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
    category: string | null,
    subcategory: string | null
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
            } else {
                throw Error("Item does not exist");
            }
        })
}

export async function updateRating(
    id: string,
    rating: number
) {
    const doc = admin.firestore().collection(TABLE_CERTIFICATIONS).doc(id);
    const docRef = await doc.get();
    if (docRef.exists) {
        await doc.update({ rating: rating })
    } else {
        throw Error("Item does not exist");
    }
}

async function getSnapshotForCategory(
    category: string | null,
    subcategory: string | null
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

function filter(text?: string) {
    // if a value is undefined or empty we always save it as
    // null in firestore
    return (text != undefined && text != "") ? text : null;
}