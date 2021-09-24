/* eslint-disable require-jsdoc */
import * as admin from 'firebase-admin';

const TABLE_CERTIFICATIONS = "User Certifications";

export class UserCertificationFirestoreError extends Error { }
export class UserCertificationExistsError extends UserCertificationFirestoreError { }
export class UserCertificationNotFoundError extends UserCertificationFirestoreError { }

export async function insert(
    uid: string,
    item: any,
) {
    const db = admin.firestore();
    const collection = db.collection(TABLE_CERTIFICATIONS);
    const snap = await collection
        .where("userId", "==", uid)
        .where("certificationId", "==", item["certificationId"]).get();
    if (!snap.empty) throw new UserCertificationExistsError();
    else {
        const doc = collection.doc(id);
        const docRef = await collection.doc(id).get();
        if (!docRef.exists) {
            doc.create({
                userId: item["userId"],
                certificationId: item["certificationId"],
                isCompleted: item["isCompleted"],
                startDate: item["startDate"],
                completionDate: item["completionDate"],
                expiryDate: item["expiryDate"],
                rating: item["rating"]
            });
            return
        } else {

        }

    }
}

export async function update(
    id: string,
    certification: any
) {
    const doc = admin.firestore().collection(TABLE_CERTIFICATIONS).doc(id);
    const docRef = await doc.get();
    if (docRef.exists) {
        doc.update(certification);
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