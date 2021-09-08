import { logger } from "firebase-functions/v1";
import { JSDOM } from "jsdom";
import { CatalogEntry } from "../catalog_entry";

export function extractSecurityCertifications(html: string, certData: CatalogEntry): Array<Certification> {
    const parser = new JSDOM(html);
    // There are 2 tables in the HTML. The first one is the details, the second one is the list of people
    const tables = parser.window.document.querySelectorAll("table");

    if (tables.length != 2) {
        throw "Invalid format. Please review the HTML matches the expected format";
    }

    const peopleTable = tables[1];
    const rows = peopleTable.querySelectorAll("tr");
    // First row is the header, the rest is the content
    const [, ...items] = rows;

    let entries = Array<Certification>();
    items.forEach(row => {
        const name = row.querySelector("td:nth-child(1)")?.textContent as string;
        const date = row.querySelector("td:nth-child(2)")?.textContent as string;
        entries.push({
            'username': name.trim(),
            'platform': "",
            'title': "API Security Architect",
            'category': certData.category,
            'subcategory': certData.subcategory,
            'date': date?.trim(),
            'description': "",
            'rating': 0
        });
    });
    logger.log(`Extracted ${entries.length}/${items.length} API Security certifications`);
    return entries;
}