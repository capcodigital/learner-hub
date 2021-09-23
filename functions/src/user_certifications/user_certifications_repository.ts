/* eslint-disable require-jsdoc */
import * as admin from 'firebase-admin';

const TABLE_CERTIFICATIONS = "User Certifications";

export class CertificationFirestoreError extends Error { }
export class CertificationsExistsError extends CertificationFirestoreError { }
export class CertificationNotFoundError extends CertificationFirestoreError { }

export async function insert(
    id: string,
    certification: any,
) {
    const db = admin.firestore();
    const collection = db.collection(TABLE_CERTIFICATIONS);
    const doc = collection.doc(id);
    const docRef = await collection.doc(id).get();
    if (!docRef.exists) {
        doc.create({
            certificationId: certification["certificationId"],
            isCompleted: certification["isCompleted"],
            startDate: certification["startDate"],
            completionDate: certification["completionDate"],
            expiryDate: certification["expiryDate"],
            rating: certification["rating"]
        });
    } else {
        throw new CertificationsExistsError();
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
        throw new CertificationNotFoundError();
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
        throw new CertificationNotFoundError();
    }
}

/*
export async function getAll(): Promise<any[]> {
    const snapshot = await admin.firestore()
        .collection(TABLE_CERTIFICATIONS).get();
    return toCertifications(snapshot);
}

async function toCertifications(snapshot: FirebaseFirestore.QuerySnapshot): Promise<any[]> {
    const users = Array<any>();
    if (!snapshot.empty) {
        snapshot.forEach((doc: { data: () => any }) => {
            var item = doc.data() as User
            users.push({
                userId: string,
                certificationId: string,
                isComplete: string,
                startDate: string,
                completionDate: string,
                expiryDate: string,
                rating: string
            });
        });
    }
    return users;
}*/