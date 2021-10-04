/* eslint-disable require-jsdoc */
import * as admin from 'firebase-admin';
import { AssocArray } from '../assoc_array';

const TABLE_CERTIFICATION_SUMMARIES = "certificationSummaries";

export class SummaryFirestoreError extends Error { }
export class SummaryNotFound extends SummaryFirestoreError { }

export async function getAllCertificationSummaries(): Promise<AssocArray> {
    const snapshot = await admin.firestore()
        .collection(TABLE_CERTIFICATION_SUMMARIES)
        .get();
    const results: AssocArray = [];
    if (!snapshot.empty) {
        snapshot.forEach((doc => {
            results.push(doc.id, toJson(doc.id, doc.data())
            );
        }));
    }
    return results;
}

export async function getCertificationSummary(id: string): Promise<any> {
    const collection = admin.firestore().collection(TABLE_CERTIFICATION_SUMMARIES);
    const doc = collection.doc(id);
    const docRef = await doc.get();
    if (!docRef.exists) throw new SummaryNotFound("Certification not found");
    else {
        return toJson(docRef.id, docRef.data());
    }
}

export async function saveSummary(summary: CertificationSummary): Promise<any> {
    const db = admin.firestore();
    const col = db.collection(TABLE_CERTIFICATION_SUMMARIES);
    const snap = await col.where("title", "==", summary.title).get();
    if (snap.empty) {
        const result = await col.add(summary);
        return toJson(result.id, summary);
    }
}

function toJson(id: string, item: any): any {
    return {
        "id": id,
        "title": item.title,
        "category": item.category,
        "platform": item.platform,
        "description": item.description,
        "link": item.link,
        "image": item.image,
        "isIndustryRecognised": item.isIndustryRecognised
    }
}

