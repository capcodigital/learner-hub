/* eslint-disable require-jsdoc */
import * as admin from 'firebase-admin';
// If skip firebase auth for quick test, then following line is needed
admin.initializeApp();
import { logger } from "firebase-functions/lib";

const TABLE_CERTIFICATIONS = "certifications"

// Saves a list of certifications in a Firestore collection
export async function save(items: Array<Certification>) {
    var batch = admin.firestore().batch();
    var collection = admin.firestore().collection(TABLE_CERTIFICATIONS);
    var snapshot = await collection.get();
    // delete all items
    snapshot.docs.forEach((doc) => {
        batch.delete(doc.ref);
    });
    // write new data, for null values we save ""
    for (var i = 0; i < items.length; i++) {
        var item = items[i];
        var itemToSave = {
            username: filter(item.username),
            platform: filter(item.platform).toLowerCase(),
            title: filter(item.title),
            category: filter(item.category).toLowerCase(),
            subcategory: filter(item.subcategory).toLowerCase(),
            date: filter(item.date),
            description: filter(item.description),
            rating: filter(item.rating),
        };
        batch.create(collection.doc(), itemToSave)
    }
    // execute operations
    await batch.commit();
}

// Returns certifications from firestore by category & subcategory as list
export async function getFromFirestoreByPlatformAsList(platform: string) {
    try {
        var snapshot = await admin.firestore()
            .collection(TABLE_CERTIFICATIONS)
            .where("platform", "==", platform)
            .get();
        const results = Array<Certification>();
        if (!snapshot.empty) {
            snapshot.forEach((doc: { data: () => any }) => {
                var item = doc.data();
                results.push(item);
            });
        }
        return results;
    } catch (e) {
        logger.log(e)
        throw e;
    }
}

// Returns certifications from firestore by category & subcategory as list
export async function getFromFirestoreByCategoryAsList(
    category: string,
    subcategory: string
) {
    try {
        var snapshot = await getFirestoreSnapshotByCategory(category, subcategory);
        const results = Array<Certification>();
        if (!snapshot.empty) {
            snapshot.forEach((doc: { data: () => any }) => {
                var item = doc.data();
                results.push(item);
            });
        }
        return results;
    } catch (e) {
        logger.log(e)
        throw e;
    }
}

// Returns a snapshot of certifications from firestore by category & subcategory
async function getFirestoreSnapshotByCategory(
    category: string,
    subcategory: string
) {
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

export async function getUserCertifications(username: string) {
    try {
        logger.log("GETTING USER CERTIFICATIONS");
        const snapshot = await admin.firestore()
            .collection("certifications")
            .where("name", "==", username)
            .get();

        const myCertifications = Array<Certification>();
        snapshot.forEach((doc: { data: () => any; }) => {
            var item = doc.data();
            logger.log(item);
            myCertifications.push(item);
        });

        return myCertifications;
    } catch (exception) {
        logger.log(exception)
        throw exception;
    }
}

// Updates the description of certifications of a given title in firestore
export async function updateDescription(
    title: string,
    desc: string
) {
    const col = admin.firestore().collection(TABLE_CERTIFICATIONS)
    await col.where('title', '==', title)
        .get()
        .then(snapshot => {
            if (snapshot.size > 0) {
                snapshot.forEach(item => {
                    col.doc(item.id).update({ description: desc })
                })
            }
        })
}

// Updates the rating of a given certification in firestore
export async function updateRating(
    certId: string,
    rating: string
) {
    await admin.firestore().collection(TABLE_CERTIFICATIONS)
        .doc(certId).update({ rating: rating })
}

function filter(text: string): string {
    return text != null ? text : "";
}
