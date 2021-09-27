/* eslint-disable require-jsdoc */
import * as admin from 'firebase-admin';
import * as summaryRepo from '../certification_summaries/certification_summary_repository';

const TABLE_CERTIFICATIONS = "User Certifications";

export class UserCertificationFirestoreError extends Error { }
export class UserCertificationExistsError extends UserCertificationFirestoreError { }
export class UserCertificationNotFoundError extends UserCertificationFirestoreError { }
export class UserNotFoundError extends UserCertificationFirestoreError { }

export async function insert(
    uid: string,
    item: any,
) {
    const db = admin.firestore();
    const collection = db.collection(TABLE_CERTIFICATIONS);
    const snap = await collection
        .where("userId", "==", uid)
        .where("certificationId", "==", item["certificationId"]).get();

    if (snap.empty) {

        const userId = item["userId"];
        const certificationId = item["certificationId"];
        const isCompleted = item["isCompleted"];
        const startDate = item["startDate"];
        const completionDate = item["completionDate"];
        const expiryDate = item["expiryDate"];
        const rating = item["rating"];

        const docRef = await collection.add({
            userId: userId,
            certificationId: certificationId,
            isCompleted: isCompleted,
            startDate: startDate,
            completionDate: completionDate,
            expiryDate: expiryDate,
            rating: rating
        });

        return {
            id: docRef.id, // adding doc id in result
            userId: userId,
            certificationId: certificationId,
            isCompleted: isCompleted,
            startDate: startDate,
            completionDate: completionDate,
            expiryDate: expiryDate,
            rating: rating
        }
    }
    else throw new UserCertificationExistsError();
}

export async function update(
    id: string,
    certification: any
) {
    const doc = admin.firestore().collection(TABLE_CERTIFICATIONS).doc(id);
    const docRef = await doc.get();
    if (docRef.exists) {
        doc.update(certification);
        const item = docRef.data() as UserCertification;
        return {
            id: docRef.id, // adding doc id in result
            userId: item.userId,
            certificationId: item.certificationId,
            isCompleted: item.isCompleted,
            startDate: item.startDate,
            completionDate: item.completionDate,
            expiryDate: item.expiryDate,
            rating: item.rating
        }
    } else {
        throw new UserCertificationNotFoundError();
    }
}

// "delete" is a reserved word
export async function deleteItem(
    id: string
) {
    const doc = admin.firestore().collection(TABLE_CERTIFICATIONS).doc(id);
    const docRef = await doc.get();
    if (docRef.exists) {
        doc.delete();
    } else {
        throw new UserCertificationNotFoundError();
    }
}

export async function getUserCertifications(uid: string): Promise<any[]> {
    const db = admin.firestore();
    const collection = db.collection(TABLE_CERTIFICATIONS);
    const snap = await collection
        .where("userId", "==", uid).get();
    return toCertifications(snap);
}

async function toCertifications(snap: FirebaseFirestore.QuerySnapshot):
    Promise<any[]> {
    const summaries = await summaryRepo.getAllCertificationSummaries();
    const items = Array<any>();
    if (!snap.empty) {
        snap.forEach((doc: { data: () => any }) => {
            var it = doc.data() as UserCertification
            const summary = summaries[it.certificationId];
            items.push({
                userId: it.userId,
                certificationSummary: summary,
                isCompleted: it.isCompleted,
                startDate: it.startDate,
                completionDate: it.completionDate,
                expiryDate: it.expiryDate,
                rating: it.rating
            });
        });
    }
    return items;
}
