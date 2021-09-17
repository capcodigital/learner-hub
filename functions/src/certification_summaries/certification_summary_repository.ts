/* eslint-disable require-jsdoc */
import * as admin from 'firebase-admin';

const TABLE_CERTIFICATION_SUMMARIES = "Certification Summaries";

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

export async function saveSummary(summary: CertificationSummary) {
    const db = admin.firestore();
    const collection = db.collection(TABLE_CERTIFICATION_SUMMARIES);
    collection.where("title", "==", summary.title)
        .get()
        .then(async (snap) => {
            if (snap.empty) {
                collection.doc().create(summary);
            }
            else {
                snap.forEach(it => {
                    collection.doc(it.id).update(summary)
                })
            }
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
