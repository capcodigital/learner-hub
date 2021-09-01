import { logger } from "firebase-functions/v1";
import { JSDOM } from "jsdom";
import { CatalogEntry } from "../catalog_entry";

export function extractCloudCertifications(html: string, certData: CatalogEntry): Array<Certification> {
    var parser = new JSDOM(html);

    var items = Array<Certification>();
    var tableRows = parser.window.document.querySelectorAll("table tr");
    for (var i = 1; i < tableRows.length; i++) {
        var cert = tableRowToCertification(tableRows[i]);
        cert.category = certData.category;
        cert.subcategory = certData.subcategory;
        items.push(cert);
    }
    logger.log(`Extracted ${items.length}/${tableRows.length - 1} Cloud certifications - ${certData.subcategory}`);
    return items;
}

// This method works for parsing the tables of the cloud certifications only.
// For the rest of certifications the tables are different so we need to create
// new method(s). Alternative is to have a common structure in the tables
// if possible, so we can use the same method for all.
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