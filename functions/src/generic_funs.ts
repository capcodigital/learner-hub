/* eslint-disable require-jsdoc */
import * as functions from "firebase-functions";
import * as admin from 'firebase-admin';
import * as axios from 'axios';
import { logger } from "firebase-functions/lib";

// Generic function to return certifications as json from a url
// and save them to a collection.
export async function getFromUrl(
    url: string,
    collectionToUpdate: string,
    response: functions.Response) {
    await axios.default.get<Certification[]>(url)
        .then(function (resp) {
            logger.log(resp);
            save(collectionToUpdate, resp.data);
            var items = JSON.stringify(resp.data);
            response.setHeader('Content-Type', 'application/json');
            response.statusCode = 200;
            response.send(items);
        })
        .catch(function (error) {
            logger.log(error);
            response.statusCode = 500;
            response.send(JSON.stringify("error occurred"));
        });
}

// Generic function to return certifications from firestore as json
export async function getCollection(
    collectionName: string,
    response: functions.Response
) {
    try {
        const snapshot = await admin.firestore().collection(collectionName).get();
        var items = Array<Certification>();
        if (!snapshot.empty) {
            // TODO: Save items as array directly, didn't find a way up to now
            snapshot.forEach(doc => {
                var item = doc.data();
                items.push({
                    name: filter(item.name),
                    platform: filter(item.platform),
                    certification: filter(item.certification),
                    category: filter(item.category),
                    subcategory: filter(item.subcategory),
                    date: filter(item.date)
                });
            });
            response.setHeader('Content-Type', 'application/json');
            response.statusCode = 200;
            response.send(JSON.stringify(items));
        }
    } catch (exception) {
        logger.log(exception)
        response.statusCode = 500;
        response.send(JSON.stringify("error occurred"));
    }
}

// Saves a list of certifications in a Firestore collection
async function save(
    collectionName: string,
    items: Array<Certification>) {
    for (var i = 0; i < items.length; i++) {
        var item = items[i];
        await admin.firestore().collection(collectionName).add({
            name: filter(item.name),
            platform: filter(item.platform),
            certification: filter(item.certification),
            category: filter(item.category),
            subcategory: filter(item.subcategory),
            date: filter(item.date)
        });
    }
}

function filter(text: string): string {
    return text != null ? text : "";
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
            myCertifications.push({
                name: filter(item.name),
                platform: filter(item.platform),
                certification: filter(item.certification),
                category: filter(item.category),
                subcategory: filter(item.subcategory),
                date: filter(item.date)
            });
        });

        return myCertifications;
    } catch (exception) {
        logger.log(exception)
        throw exception;
    }
}