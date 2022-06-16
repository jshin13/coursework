import argparse
import logging

import requests

"""
Skeleton for Squirro Delivery Hiring Coding Challenge
August 2021
"""


log = logging.getLogger(__name__)


class NYTimesSource(object):
    """
    A data loader plugin for the NY Times API.
    """

    def __init__(self):
        pass

    def connect(self, inc_column=None, max_inc_value=None):
        log.debug("Incremental Column: %r", inc_column)
        log.debug("Incremental Last Value: %r", max_inc_value)

    def disconnect(self):
        """Disconnect from the source."""
        # Nothing to do
        pass

    def flatten_dict(self, d, delimiter='.'):
        """Returns flattened dictionary

        :takes nested dictionary and flattens it into a flatten dicitonary using
            the delimiter to distinguish nested keys within the item. If multiple
            items of the same key exists, then such items are stored as a list. 
            The function also assumes that the depth of nested dictionary is no
            deeper than 2 levels in other words, there is no doubly nested 
            configuration.
        """

        new_d = {}

        for key, item in d.items():
            if isinstance(item, list):
                for n in item:
                    for nested_key, nested_item in n.items():
                        new_key = key + delimiter + nested_key
                        if new_key in new_d.keys():
                            new_d[new_key].append(nested_item)
                        else:
                            new_d[new_key] = [nested_item]
            elif isinstance(item, dict):
                for nested_key, nested_item in item.items():
                    new_key = key + delimiter + nested_key
                    if new_key in new_d.keys():
                        new_d[new_key].append(nested_item)
                    else:
                        new_d[new_key] = [nested_item]
            else:
                new_d[key] = item

        return new_d

    def getDataBatch(self, batch_size):
        """
        Generator - Get data from source on batches.

        :returns One list for each batch. Each of those is a list of
                 dictionaries with the defined rows.
        """
        # TODO: implement - this dummy implementation returns one batch of data
        params = {
            'api-key': self.args.api_key,
            'query': self.args.query,
            'page': 1
        }

        url = 'https://api.nytimes.com/svc/search/v2/articlesearch.json'

        r = requests.get(url, params=params)
        bucket = [] #initialize temporary bucket

        while r.ok:
            tmp = []
            bucket += r.json()['response']['docs']

            if batch_size > len(bucket):
                pass
            else:
                for i in range(batch_size):
                    doc = bucket.pop(0)

                    new_doc = self.flatten_dict(d=doc)

                    tmp.append(
                        {
                            "headline.main": new_doc['headline.main'][0],
                            "_id": new_doc['_id']
                        }
                    )

                yield tmp

            params['page'] += 1
            r = requests.get(url, params=params)

        # the connection is allowed to terminate with the following log message
        status = ['succeeded' if r.ok else 'failed']
        print(f'Loading further page {status[0]} in an attempt to load page {params["page"]}')

    def getSchema(self):
        """
        Return the schema of the dataset
        :returns a List containing the names of the columns retrieved from the
        source
        """

        schema = [
            "title",
            "body",
            "created_at",
            "id",
            "summary",
            "abstract",
            "keywords",
        ]

        return schema


if __name__ == "__main__":
    config = {
        "api_key": "fdk3tUmhKNyAQyIPAVL8jHe0t6AV4QXU",
        "query": "Silicon Valley",
    }
    source = NYTimesSource()

    # This looks like an argparse dependency - but the Namespace class is just
    # a simple way to create an object holding attributes.
    source.args = argparse.Namespace(**config)

    for idx, batch in enumerate(source.getDataBatch(10)):
        print(f"{idx} Batch of {len(batch)} items")
        for item in batch:
            print(f"  - {item['_id']} - {item['headline.main']}")
