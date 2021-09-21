/* eslint-disable require-jsdoc */
import * as admin from 'firebase-admin';

const TABLE_CERTIFICATION_SUMMARIES = "Certification Summaries";

export async function getAllCertificationSummaries(): Promise<any[]> {
    const snapshot = await admin.firestore()
        .collection(TABLE_CERTIFICATION_SUMMARIES)
        .get();
    const results = Array<any>();
    if (!snapshot.empty) {
        snapshot.forEach((doc => {
            results.push(toJson(doc.data(), doc.id)
            );
        }));
    }
    return results;
}

export async function getCertificationSummary(id: string): Promise<any> {
    const collection = admin.firestore().collection(TABLE_CERTIFICATION_SUMMARIES);
    const doc = collection.doc(id);
    const docRef = await doc.get();
    if (!docRef.exists) throw Error("Certification not found");
    else {
        return toJson(docRef.data(), docRef.id);
    }
}

export async function saveSummary(summary: CertificationSummary): Promise<any> {
    const db = admin.firestore();
    const col = db.collection(TABLE_CERTIFICATION_SUMMARIES);
    const snap = await col.where("title", "==", summary.title).get();
    if (snap.empty) {
        const result = await col.add(summary);
        return toJson(summary, result.id);
    }
}

function toJson(item: any, id: string): any {
    return {
        "id": id,
        "title": item.title,
        "category": item.category,
        "platform": item.platform,
        "description": item.description,
        "link": item.link,
        "image": item.image
    }
}