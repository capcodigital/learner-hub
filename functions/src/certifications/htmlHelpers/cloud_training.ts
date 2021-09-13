import { logger } from "firebase-functions/v1";
import { JSDOM } from "jsdom";
import { CatalogEntry } from "../catalog_entry";

export function extractCloudCertifications(html: string, certData: CatalogEntry): Array<Certification> {
    var items = Array<Certification>();
    const parser = new JSDOM(html);
    var tableRows = parser.window.document.querySelectorAll("table tr");
    tableRows.forEach(row => {
        items.push(toCertification(row, certData.category, certData.subcategory));
    });
    logger.log(`Extracted ${items.length}/${tableRows.length - 1} Cloud certifications - ${certData.subcategory}`);
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
        'username': username?.trim(),
        'platform': platform?.trim().toLowerCase(),
        'title': title?.trim(),
        'category': category?.toLowerCase(),
        'subcategory': subcategory?.toLowerCase(),
        'date': date?.trim(),
        'description': "",
        'rating': 0
    };
}