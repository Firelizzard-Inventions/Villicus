//
//  types.h
//  Villicus
//
//  Created by Ethan Reesor on 9/9/12.
//  Copyright (c) 2012 Ethan Reesor. All rights reserved.
//

#ifndef Villicus_types_h
#define Villicus_types_h

struct queue_elem_t {
	void *data;
	struct queue_elem_t *next;
};

typedef struct queue_elem_t queue_elem;

#endif
