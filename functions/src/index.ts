import * as functions from "firebase-functions";
import express, { Request, Response } from "express";
import { validateFirebaseIdToken } from "./auth-middleware";
import * as admin from 'firebase-admin';
import * as axios from 'axios';

export const app = express();
app.use(validateFirebaseIdToken);

app.get("/hello", (req: Request, res: Response) => {
    // Sample code to test the auth middleware
    const tokenId = !req.headers.authorization || req.headers.authorization.split("Bearer ")[1];
    res.send(
        {
            token: tokenId,
            user: req.user?.name,
        }
    );
});

// This HTTPS endpoint can only be accessed by your Firebase Users.
// Requests need to be authorized by providing an `Authorization` HTTP header
// with value `Bearer <Firebase ID Token>`.
exports.app = functions.https.onRequest(app);

// ------ CLOUD FUNCTIONS ------------
interface Certification {
    name: number;
    platform: string;
    certification: string;
    date: string;
}

exports.getFromConfluence = functions.https.onRequest(async (req, res) => {
    getFromUrl('https://io-capco-flutter-dev.nw.r.appspot.com/completed', "certifications", res);
});

// Generic function to return certifications from a url
// and save them to a collection.
async function getFromUrl(
    url: string,
    collectionToUpdate: string,
    response: functions.Response) {
    var output = "[]";
    await axios.default.get<Certification[]>(url)
        .then(function (resp) {
            console.log(resp);
            save(collectionToUpdate, resp.data);
            output = JSON.stringify(resp.data);
            response.statusCode = 200;
        })
        .catch(function (error) {
            console.log(error);
            output = "[]";
        })
        .then(function () {
            response.send(output);
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

// Retrieves the certifications from Firestore and returns them as json
exports.getFromFirestore = functions.https.onRequest(async (req, res) => {
    getCollection('certifications', res);
});

// Retrieves a collection of certifications from Firestore and returns them as json
async function getCollection(
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
