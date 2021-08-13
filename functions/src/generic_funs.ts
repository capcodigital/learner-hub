import * as functions from "firebase-functions";
import * as admin from 'firebase-admin';
import * as axios from 'axios';

// Generic function to return certifications from a url
// and save them to a collection.
export async function getFromUrl(
    url: string,
    collectionToUpdate: string,
    response: functions.Response) {
    var items = "[]";
    await axios.default.get<Certification[]>(url)
        .then(function (resp) {
            console.log(resp);
            save(collectionToUpdate, resp.data);
            items = JSON.stringify(resp.data);
            response.statusCode = 200;
        })
        .catch(function (error) {
            console.log(error);
            items = "[]";
        })
        .then(function () {
            response.send(items);
        });
}

// Saves a list of certifications in a Firestore collection
async function save(
    collectionName: string,
    items: Array<Certification>) {
    for (var i = 0; i < items.length; i++) {
        var item = items[i];
        await admin.firestore().collection(collectionName).add({
            name: item.name,
            platform: item.platform,
            certification: item.certification,
            date: item.date
        });
    }
}

// Retrieves a collection of certifications from Firestore and returns them as json
export async function getCollection(
    collectionName: string,
    response: functions.Response
) {
    const snapshot = await admin.firestore().collection(collectionName).get();
    var items = Array<Certification>();
    if (!snapshot.empty) {
        // TODO: Save items as array directly, didn't find a way up to now
        snapshot.forEach(doc => {
            var item = doc.data();
            items.push({
                "name": item.name,
                "platform": item.platform,
                "certification": item.certification,
                "date": item.date
            });
        });
    }
    response.statusCode = 200;
    response.send(JSON.stringify(items));
}
