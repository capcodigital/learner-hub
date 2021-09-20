/* eslint-disable require-jsdoc */
import * as admin from 'firebase-admin';

const TABLE_CERTIFICATION_SUMMARIES = "Certification Summaries";

export async function getAlCertificationSummaries(): Promise<any[]> {
    const snapshot = await admin.firestore()
        .collection(TABLE_CERTIFICATION_SUMMARIES)
        .get();
    const results = Array<any>();
    if (!snapshot.empty) {
        snapshot.forEach((doc => {
            const item = doc.data();
            results.push({
                "id": doc.id,
                "title": item.title,
                "category": item.category,
                "platform": item.platform,
                "description": item.description,
                "link": item.link,
                "image": item.image
            });
        }));
    }
    return results;
}

export async function getCertificationSummary(id: string): Promise<any> {
    const collection = admin.firestore().collection(TABLE_CERTIFICATION_SUMMARIES);
    const doc = collection.doc(id);
    const docRef = await doc.get();
    if (!docRef.exists) throw Error("Certification Summary does not exist");
    else {
        const item = docRef.data() as CertificationSummary;
        return {
            "id": doc.id,
            "title": item.title,
            "category": item.category,
            "platform": item.platform,
            "description": item.description,
            "link": item.link,
            "image": item.image
        };
    }
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
