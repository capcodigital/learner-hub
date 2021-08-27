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
const UNRATED: number = 0

export async function getFromConfluence(
    username: string,
    token: string,
    entries: CatalogEntry[],
    res: functions.Response) {
    const auth: axios.AxiosBasicCredentials = {
        username: username,
        password: token
    }
    getFromConfluenceAuthorised(auth, entries, res);
}

// Gets the certifications for the given catalog entries from confluence,
// saves them to Firestore and returns them all as json
async function getFromConfluenceAuthorised(
    creds: axios.AxiosBasicCredentials,
    entries: CatalogEntry[],
    res: functions.Response) {
    var reqs = Array<Promise<axios.AxiosResponse<ConfluenceResponse>>>();
    entries.forEach(entry => {
        const req = axios.default.get<ConfluenceResponse>(entry.contentUrl, {
            auth: creds
        });
        reqs.push(req);
    });
    await axios.default
        .all(reqs)
        .then(function (resps) {
            var allItems = Array<Certification>();
            for (var i = 0; i < resps.length; i++) {
                var items = Array<Certification>();
                var html = resps[i].data.body.export_view.value;
                var items = createCertificationArray(
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

function createCertificationArray(
    html: string,
    category: string,
    subcategory: string,
): Array<Certification> {
    var items = Array<Certification>();
    const parser = new JSDOM(html);
    var tableRows = parser.window.document.querySelectorAll("table tr");
    tableRows.forEach(row => {
        items.push(toCertification(row, category, subcategory));
    });
    return items;
}

// This method works for parsing the tables of the cloud certifications only.
// For the rest of certifications the tables are different so we need to create
// new method(s). Alternative is to have a common structure in the tables
// if possible, so we can use the same method for all.
function toCertification(
    row: Element,
    category: string,
    subcategory: string): Certification {
    const username = row.querySelector('td:nth-child(2)')?.textContent as string;
    const platform = row.querySelector('td:nth-child(3)')?.textContent as string;
    const title = row.querySelector('td:nth-child(4)')?.textContent as string;
    const date = row.querySelector('td:nth-child(5)')?.textContent as string;
    return {
        'username': filter(username?.trim()),
        'platform': filter(platform?.trim()).toLowerCase(),
        'title': filter(title?.trim()),
        'category': category.toLowerCase(),
        'subcategory': subcategory.toLowerCase(),
        'date': filter(date?.trim()),
        'description': "",
        'rating': UNRATED
    };
}

// Sends response with certifications from firestore by platform as json
export async function getFromFirestoreByPlatform(
    platform: string,
    res: functions.Response) {
    try {
        const items = await getFromFirestoreByPlatformAsList(platform);
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
        const items = await getFromFirestoreByCategoryAsList(category, subcategory);
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
    rating: number,
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
    rating: number,
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

function filter(text: string): string {
    return text != null ? text : "";
}