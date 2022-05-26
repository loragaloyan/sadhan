import pymongo

def create_all_indices(db):
    # The index types are unclear to me but using `TEXT` (for start) gives an error.
    db['user'].create_index([('email', pymongo.ASCENDING), \
        ('username', pymongo.ASCENDING)], unique=True)

    db['image'].create_index([('title', pymongo.ASCENDING), \
        ('url', pymongo.ASCENDING), ('user_id_creator', pymongo.ASCENDING)], unique=True)

    db['userMeditation'].create_index([('userId', pymongo.ASCENDING), \
        ('start', pymongo.ASCENDING)], unique=True)

    # db['userFollow'].create_index([('userId', pymongo.ASCENDING), \
    #     ('userIdFollow', pymongo.ASCENDING)], unique=True)
