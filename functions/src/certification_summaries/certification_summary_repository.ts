/* eslint-disable require-jsdoc */
import * as admin from 'firebase-admin';
//import { logger } from 'firebase-functions/v1';

const TABLE_CERTIFICATION_SUMMARIES = "CertificationSummaries";

export async function getAlCertificationSummaries(): Promise<CertificationSummary[]> {
    const snapshot = await admin.firestore()
        .collection(TABLE_CERTIFICATION_SUMMARIES)
        .get();
    return toCertificationSummaries(snapshot);
}

export async function saveSummary(item: CertificationSummary) {
    const db = admin.firestore();
    const collection = db.collection(TABLE_CERTIFICATION_SUMMARIES);
    collection
        .where("title", "==", item.title)
        .get()
        .then(async (snap) => {
            if (snap.empty) {
                addCertificationSummary(collection, item);
            } else {
                // If item exists, udpate fields
                snap.forEach(it => {
                    collection.doc(it.id).update({
                        platform: filter(item.platform),
                        category: filter(item.category),
                        //subcategory: filter(item.subcategory),
                        //date: filter(item.date),
                    })
                })
            }
        });
}

function addCertificationSummary(
    collection: FirebaseFirestore.CollectionReference,
    item: CertificationSummary
) {
    collection.doc().create({
        //username: filter(item.username),
        platform: filter(item.platform),
        title: filter(item.title),
        category: filter(item.category),
        //subcategory: filter(item.subcategory),
        //date: filter(item.date),
        description: filter(item.description),
        //rating: item.rating,
    });
}

async function toCertificationSummaries(snapshot: FirebaseFirestore.QuerySnapshot):
    Promise<CertificationSummary[]> {
    const results = Array<CertificationSummary>();
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