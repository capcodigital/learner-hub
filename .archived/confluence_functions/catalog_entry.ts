import data from './catalog.json';

export type CatalogEntry = {
    id: number;
    name: string;
    category: string;
    subcategory: string;
    url: string;
    contentUrl: string;
};

export const getUrl = (id: number): string => {
    return getById(id).url;
}

export const getById = (id: number): CatalogEntry => {
    return data.find((element: CatalogEntry) => element.id == id) as CatalogEntry;
}