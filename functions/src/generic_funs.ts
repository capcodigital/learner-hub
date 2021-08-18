import * as functions from "firebase-functions";
import * as admin from 'firebase-admin';
admin.initializeApp();
import * as axios from 'axios';
import { logger } from "firebase-functions/lib";
import * as jsdom from "jsdom";
const { JSDOM } = jsdom;

const TABLE_CERTIFICATIONS = "certifications"

export async function getFromConfuence(
    username: string,
    token: string,
    url: string,
    category: string,
    subcategory: string,
    res: functions.Response) {
    var auth: axios.AxiosBasicCredentials = {
        username: username,
        password: token
    }
    getFromUrlAuthorised(auth, url, category, subcategory, res);
}

async function getFromUrlAuthorised(
    creds: axios.AxiosBasicCredentials,
    url: string,
    category: string,
    subcategory: string,
    res: functions.Response) {
    await axios.default.get<ConfluenceResponse>(url, {
        auth: creds
    }).then(function (resp) {
        var html = resp.data.body.export_view.value;
        var items = getCertificationsFromHtml(html);
        addCategories(items, category, subcategory);
        save(items);
        res.setHeader('Content-Type', 'application/json');
        res.statusCode = 200;
        res.send(JSON.stringify(items));
    }).catch(function (error) {
        logger.log(error);
        res.statusCode = 500;
        res.send(JSON.stringify("error occurred"));
    });
}

function getCertificationsFromHtml(html: string): Array<Certification> {
    var items = Array<Certification>();
    var parser = new JSDOM(html);
    var tableRows = parser.window.document.querySelectorAll("table tr");
    for (var i = 1; i < tableRows.length; i++) {
        var cert = tableRowToCertification(tableRows[i]);
        items.push(cert);
    }
    return items;
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
export async function save(items: Array<Certification>) {
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

// TODO: Probably remove this method, no need
// Sends response with all certifications from firestore as json
export async function getFromFirestoreAll(
    res: functions.Response
) {
    try {
        var items = await getFromFirestoreAllAsList();
        res.setHeader('Content-Type', 'application/json');
        res.statusCode = 200;
        res.send(JSON.stringify(items));
    } catch (e) {
        logger.log(e)
        res.statusCode = 500;
        res.send(JSON.stringify("error occurred"));
    }
}

// Sends response with certifications from firestore by category as json
export async function getFromFirestoreByCategory(
    category: String,
    subcategory: String,
    res: functions.Response) {
    try {
        var items = await getFromFirestoreByCategoryAsList(category, subcategory);
        res.setHeader('Content-Type', 'application/json');
        res.statusCode = 200;
        res.send(JSON.stringify(items));
    } catch (e) {
        logger.log(e)
        res.statusCode = 500;
        res.send(JSON.stringify("error occurred"));
    }
}

// TODO: Probably remove this method, no need
// Returns all certifications from firestore as list
async function getFromFirestoreAllAsList() {
    try {
        const snapshot = await admin.firestore()
            .collection(TABLE_CERTIFICATIONS)
            .get();
        const results = Array<Certification>();
        if (!snapshot.empty) {
            snapshot.forEach((doc: { data: () => any }) => {
                var item = doc.data();
                logger.log(item);
                results.push({
                    name: filter(item.name),
                    platform: filter(item.platform),
                    certification: filter(item.certification),
                    category: filter(item.category),
                    subcategory: filter(item.subcategory),
                    date: filter(item.date),
                    description: filter(item.description),
                    rating: filter(item.rating)
                });
            });
        }
        return results;
    } catch (e) {
        logger.log(e)
        throw e;
    }
}

// Returns certifications from firestore by category & subcategory as list
async function getFromFirestoreByCategoryAsList(
    category: String,
    subcategory: String
) {
    try {
        const snapshot = await admin.firestore()
            .collection(TABLE_CERTIFICATIONS)
            .where("category", "==", category)
            .where("subcategory", "==", subcategory)
            .get();
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

function filter(text: string): string {
    return text != null ? text : "";
}