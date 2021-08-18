import * as functions from "firebase-functions";
import * as admin from 'firebase-admin';
admin.initializeApp();
import * as axios from 'axios';
import { logger } from "firebase-functions/lib";
import * as jsdom from "jsdom";
const { JSDOM } = jsdom;
import { Certification } from "./certification";
import { CertificationConflu } from "./certification";

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

export async function getFromUrl2(
    url: string,
    response: functions.Response) {
    await axios.default.get<ConfluenceResponse>(url, {
        auth: {
            username: "haris.mexis@capco.com",
            password: "2Yxpj3vyhdaAmrQsM1u9CBFA"
        }
    })
        .then(function (resp) {
            var html = resp.data.body.export_view.value;
            var parser = new JSDOM(html);
            var tableRows = parser.window.document.querySelectorAll("table tr");
            var items = Array<CertificationConflu>();
            for (var i = 1; i < tableRows.length; i++) {
                var name = tableRows[i].querySelector('td:nth-child(2)')?.textContent as string;
                var platform = tableRows[i].querySelector('td:nth-child(3)')?.textContent as string;
                var certification = tableRows[i].querySelector('td:nth-child(4)')?.textContent as string;
                var date = tableRows[i].querySelector('td:nth-child(5)')?.textContent as string;
                //var type = tableRows[i].querySelector('td:nth-child(6)')?.textContent as string;
                var cert: CertificationConflu = {
                    'name': name,
                    'platform': platform,
                    'certification': certification,
                    'category': "",
                    'subcategory': "",
                    'date': date,
                };
                items.push(cert);
            }
            save2("certifications", items);
            var jsonString = JSON.stringify(items)
            response.statusCode = 200;
            response.send(jsonString);
        })
        .catch(function (error) {
            logger.log(error);
            response.statusCode = 500;
            response.send(JSON.stringify("error occurred"));
        });
}

// Saves a list of certifications in a Firestore collection
export async function save2(
    collectionName: string,
    items: Array<CertificationConflu>) {
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