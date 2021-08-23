/* eslint-disable require-jsdoc */
import * as functions from "firebase-functions";
import * as admin from 'firebase-admin';
import * as axios from 'axios';
import { logger } from "firebase-functions/lib";
import * as jsdom from "jsdom";
import { CatalogEntry } from "./certifications";

const { JSDOM } = jsdom;

const TABLE_CERTIFICATIONS = "certifications"

export async function getFromConfluence(
    username: string,
    token: string,
    catalogEntries: Array<CatalogEntry>,
    res: functions.Response) {
    var auth: axios.AxiosBasicCredentials = {
        username: username,
        password: token
    }
    getFromUrlsAuthorised(auth, catalogEntries, res);
}

// Gets the certifications for the given catalog entries from confluence,
// saves them to Firestore and returns them all as json
async function getFromUrlsAuthorised(
    creds: axios.AxiosBasicCredentials,
    entries: Array<CatalogEntry>,
    res: functions.Response) {
    // prepare array of requests
    var reqs = Array<Promise<axios.AxiosResponse<ConfluenceResponse>>>();
    for (var i = 0; i < entries.length; i++) {
        var req = axios.default.get<ConfluenceResponse>(entries[i].contentUrl, {
            auth: creds
        });
        reqs.push(req);
    }
    // execute all requests
    await axios.default
        .all(reqs)
        .then(function (resps) {
            var allItems = Array<Certification>();
            for (var i = 0; i < resps.length; i++) {
                var items = Array<Certification>();
                var html = resps[i].data.body.export_view.value;
                var items = getCertificationsFromHtml(html);
                logger.log(items.length);
                addCategories(
                    items,
                    entries[i].category,
                    entries[i].subcategory);
                save(items);
                for (var j = 0; j < items.length; j++) {
                    allItems.push(items[j]);
                }
            }
            logger.log(allItems.length);
            res.setHeader('Content-Type', 'application/json');
            res.statusCode = 200;
            res.send(JSON.stringify(allItems));
        }).catch(errors => {
            logger.log(errors);
            res.statusCode = 500;
            res.send(JSON.stringify("error occurred"));
        })
}

function addCategories(
    items: Array<Certification>,
    category: string,
    subcategory: string
): Array<Certification> {
    for (var i = 0; i < items.length; i++) {
        items[i].category = category;
        items[i].subcategory = subcategory;
    }
    return items;
}

function getCertificationsFromHtml(html: string): Array<Certification> {
    var items = Array<Certification>();
    var parser = new JSDOM(html);
    var tableRows = parser.window.document.querySelectorAll("table tr");
    for (var i = 1; i < tableRows.length; i++) {
        items.push(tableRowToCertification(tableRows[i]));
    }
    return items;
}

function tableRowToCertification(row: Element): Certification {
    var name = row.querySelector('td:nth-child(2)')?.textContent as string;
    var platform = row.querySelector('td:nth-child(3)')?.textContent as string;
    var certification = row.querySelector('td:nth-child(4)')?.textContent as string;
    var date = row.querySelector('td:nth-child(5)')?.textContent as string;
    var cert: Certification = {
        'name': name?.trim(),
        'platform': platform?.trim(),
        'certification': certification?.trim(),
        'category': "", // This will be assigned afterwards
        'subcategory': "", // This will be assigned afterwards
        'date': date?.trim(),
        'description': "", // This will be assigned afterwards
        'rating': "" // This will be assigned afterwards
    };
    return cert;
}

// Saves a list of certifications in a Firestore collection
async function save(items: Array<Certification>) {
    for (var i = 0; i < items.length; i++) {
        var item = items[i];
        await admin.firestore().collection(TABLE_CERTIFICATIONS).add({
            name: filter(item.name),
            platform: filter(item.platform),
            certification: filter(item.certification),
            category: filter(item.category).toLowerCase(),
            subcategory: filter(item.subcategory).toLowerCase(),
            date: filter(item.date),
            description: filter(item.description),
            rating: filter(item.rating),
        });
    }
}

// Sends response with certifications from firestore by category & subcategory as json
export async function getFromFirestoreByCategory(
    category: string,
    subcategory: string,
    res: functions.Response) {
    try {
        var items = await getFromFirestoreByCategoryAsList(category, subcategory);
        res.setHeader('Content-Type', 'application/json');
        res.statusCode = 200;
        res.send(JSON.stringify(items));
    } catch (e) {
        logger.log(e)
        res.statusCode = 500;
        res.send(JSON.stringify(e.message));
    }
}

// Returns certifications from firestore by category & subcategory as list
async function getFromFirestoreByCategoryAsList(
    category: string,
    subcategory: string
) {
    try {
        var snapshot = await getFirestoreSnapshotByCategory(category, subcategory);
        const results = Array<Certification>();
        if (!snapshot.empty) {
            snapshot.forEach((doc: { data: () => any }) => {
                var item = doc.data();
                results.push({
                    name: filter(item.name),
                    platform: filter(item.platform),
                    certification: filter(item.certification),
                    category: filter(item.category),
                    subcategory: filter(item.subcategory),
                    date: filter(item.date),
                    description: filter(item.description),
                    rating: filter(item.rating),
                });
            });
        }
        return results;
    } catch (e) {
        logger.log(e)
        throw e;
    }
}

// Returns a snapshot of certifications from firestore by category & subcategory
async function getFirestoreSnapshotByCategory(
    category: string,
    subcategory: string
) {
    try {
        var snapshot = null;
        if (category != null && subcategory != null) {
            snapshot = await admin.firestore()
                .collection(TABLE_CERTIFICATIONS)
                .where("category", "==", category)
                .where("subcategory", "==", subcategory)
                .get();
        } else if (category != null) {
            snapshot = await admin.firestore()
                .collection(TABLE_CERTIFICATIONS)
                .where("category", "==", category)
                .get();
        } else if (subcategory != null) {
            snapshot = await admin.firestore()
                .collection(TABLE_CERTIFICATIONS)
                .where("subcategory", "==", subcategory)
                .get();
        } else {
            snapshot = await admin.firestore()
                .collection(TABLE_CERTIFICATIONS)
                .get();
        }
        logger.log(snapshot.size);
        return snapshot;
    } catch (e) {
        logger.log(e)
        throw e;
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
                date: filter(item.date),
                description: filter(item.description),
                rating: filter(item.rating),
            });
        });

        return myCertifications;
    } catch (exception) {
        logger.log(exception)
        throw exception;
    }
}