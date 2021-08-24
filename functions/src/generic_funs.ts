/* eslint-disable require-jsdoc */
import * as functions from "firebase-functions";
import * as axios from 'axios';
import { logger } from "firebase-functions/lib";
import * as jsdom from "jsdom";
import { CatalogEntry } from "./certifications/catalog_entry";
import {
    save,
    getFromFirestoreByPlatformAsList,
    getFromFirestoreByCategoryAsList,
    updateDescription,
    updateRating
} from "./firestore_funs";

const { JSDOM } = jsdom;

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
                var items = getCertificationsFromHtml(
                    html,
                    entries[i].category,
                    entries[i].subcategory);
                logger.log(items.length);
                save(items);
                allItems.push.apply(allItems, items);
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

function getCertificationsFromHtml(
    html: string,
    category: string,
    subcategory: string,
): Array<Certification> {
    var items = Array<Certification>();
    var parser = new JSDOM(html);
    var tableRows = parser.window.document.querySelectorAll("table tr");
    for (var i = 1; i < tableRows.length; i++) {
        var cert = tableRowToCertification(tableRows[i]);
        cert.category = category;
        cert.subcategory = subcategory;
        items.push(cert);
    }
    return items;
}

// This method works for parsing the tables of the cloud certifications only.
// For the rest of certifications the tables are different so we need to create
// new method(s). Alternative is to have a common structure in the tables
// if possible, so we can use the same method for all.
function tableRowToCertification(row: Element): Certification {
    var username = row.querySelector('td:nth-child(2)')?.textContent as string;
    var platform = row.querySelector('td:nth-child(3)')?.textContent as string;
    var title = row.querySelector('td:nth-child(4)')?.textContent as string;
    var date = row.querySelector('td:nth-child(5)')?.textContent as string;
    var cert: Certification = {
        'username': username?.trim(),
        'platform': platform?.trim(),
        'title': title?.trim(),
        'category': "", // This will be assigned afterwards
        'subcategory': "", // This will be assigned afterwards
        'date': date?.trim(),
        'description': "", // This will be assigned afterwards
        'rating': "" // This will be assigned afterwards
    };
    return cert;
}

// Sends response with certifications from firestore by platform as json
export async function getFromFirestoreByPlatform(
    platform: string,
    res: functions.Response) {
    try {
        var items = await getFromFirestoreByPlatformAsList(platform);
        res.setHeader('Content-Type', 'application/json');
        res.statusCode = 200;
        res.send(JSON.stringify(items));
    } catch (e) {
        logger.log(e)
        res.statusCode = 500;
        res.send(JSON.stringify(e.message));
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

// Updates the description of certifications of a given title in firestore
// and returns a response
export async function describe(
    title: string,
    desc: string,
    res: functions.Response
) {
    try {
        updateDescription(title, desc);
        res.statusCode = 200;
        res.send(JSON.stringify("success"));
    } catch (e) {
        res.statusCode = 500;
        res.send(JSON.stringify(e));
    }
}

// Updates the rating of certifications of a given id in firestore
// and returns a response
export async function rate(
    certId: string,
    rating: string,
    res: functions.Response
) {
    try {
        updateRating(certId, rating);
        res.statusCode = 200;
        res.send(JSON.stringify("success"));
    } catch (e) {
        res.statusCode = 500;
        res.send(JSON.stringify(e));
    }
}

// Executes PUT request to add description to a certification
export async function putDescription(
    url: string,
    certTitle: string,
    description: string,
    res: functions.Response) {
    const fullUrl = url + "?title=" + certTitle;
    await axios.default.put(fullUrl,
        { desc: description })
        .then(function (resp) {
            res.statusCode = 200;
            res.send(resp.data);
        }).catch((e) => {
            console.log(e);
            res.statusCode = 500;
            res.send("error");
        });
}

// Executes PUT request to add rating to a certification
export async function putRating(
    url: string,
    certId: string,
    rating: string,
    res: functions.Response) {
    const fullUrl = url + "?id=" + certId;
    await axios.default.put(fullUrl,
        { rating: rating })
        .then(function (resp) {
            res.statusCode = 200;
            res.send(resp.data);
        }).catch((e) => {
            logger.log(e);
            res.statusCode = 500;
            res.send("error");
        });
}

