/* eslint-disable require-jsdoc */
import * as admin from 'firebase-admin';
//import { logger } from 'firebase-functions/v1';

const TABLE_CERTIFICATION_SUMMARIES = "CertificationSummaries";

export async function getAlCertificationSummaries(): Promise<CertificationSummary[]> {
    const snapshot = await admin.firestore()
        .collection(TABLE_CERTIFICATION_SUMMARIES)
        .get();
    return toSummaries(snapshot);
}

export async function getCertificationSummary(id: string): Promise<CertificationSummary> {
    const collection = admin.firestore().collection(TABLE_CERTIFICATION_SUMMARIES);
    const doc = collection.doc(id);
    const docRef = await doc.get();
    if (!docRef.exists) throw Error("Certification Summary does not exist");
    else return docRef.data() as CertificationSummary
}

export async function saveSummary(summary: any) {
    const db = admin.firestore();
    const collection = db.collection(TABLE_CERTIFICATION_SUMMARIES);
    collection.where("title", "==", summary.title)
        .get()
        .then(async (snap) => {
            if (snap.empty) {
                addSummary(collection, summary);
            }
            else {
                snap.forEach(it => {
                    collection.doc(it.id).update({
                        category: filter(summary["category"]),
                        platform: filter(summary["platform"]),
                        title: filter(summary["title"]),
                        description: filter(summary["description"]),
                        link: filter(summary["link"]),
                        image: filter(summary["image"])
                    })
                })
            }
        });
}

function addSummary(
    collection: FirebaseFirestore.CollectionReference,
    summary: any
) {
    collection.doc().create({
        category: filter(summary["category"]),
        platform: filter(summary["platform"]),
        title: filter(summary["title"]),
        description: filter(summary["description"]),
        link: filter(summary["link"]),
        image: filter(summary["image"])
    });
}

async function toSummaries(snapshot: FirebaseFirestore.QuerySnapshot):
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