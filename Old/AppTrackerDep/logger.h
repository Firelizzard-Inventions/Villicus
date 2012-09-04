/*
 *  logger.h
 *  AppTracker
 *
 *  Created by Ethan Reesor on 8/19/10.
 *  Copyright 2010 Ethan Reesor. All rights reserved.
 *
 */

#include <stdio.h>
#include <strings.h>
#include <fcntl.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/ioctl.h>
//#include <sys/types.h>
#include <sys/sysctl.h>
#include "fsevents.h"
//#include <pwd.h>
//#include <grp.h>
#include <errno.h>

#define BUFFER_SIZE		131072          // buffer for reading from the device
#define QUEUE_SIZE		4096            // limited by MAX_KFS_EVENTS
#define NUM_EVENT_ARGS	FSE_MAX_ARGS

typedef int FILEDESC;

typedef struct fsevent_clone_args fsevent_clone_args_t;

typedef struct fs_event_arg {
	u_int16_t	type;
	u_int16_t	length;
	union {
		struct vnode	*vnode;
		char			*string;
		char			*path;
		int32_t			int32;
		int64_t			int64;
		void			*pointer;
		ino_t			inode;
		uid_t			userid;
		dev_t			device;
		int32_t			mode;
		gid_t			groupid;
		// FSE_ARG_FINFO?
	} data;
} fs_event_arg_t;

typedef struct fs_event {
	int32_t			type;
	pid_t			procid;
//	fs_event_arg_t	*arguments;
	fs_event_arg_t	arguments[NUM_EVENT_ARGS];
} fs_event_t;

int handle_event(fs_event_t * event);
int handle_args(fs_event_arg_t * arg);