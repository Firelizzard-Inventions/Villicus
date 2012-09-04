/*
 *  logger.c
 *  AppTracker
 *
 *  Created by Ethan Reesor on 8/19/10.
 *  Copyright 2010 Ethan Reesor. All rights reserved.
 *
 */

/*
 *	Error Codes:
 *
 *	1 - Unknown Error
 */

#include "logger.h"

int main(int argc, char *argv[]) {
	boolean_t run = TRUE;
	int bytes_read, fse_ptr_offset = 0;
	char buffer[BUFFER_SIZE], inbuffer[1];
	FILEDESC fsedev_desc, fsedd_clone;
	fsevent_clone_args_t clone_args;
    int8_t clone_event_list[] = {
		FSE_REPORT,  // FSE_CREATE_FILE,
		FSE_REPORT,  // FSE_DELETE,
		FSE_IGNORE,  // FSE_STAT_CHANGED,
		FSE_REPORT,  // FSE_RENAME,
		FSE_REPORT,  // FSE_CONTENT_MODIFIED,
		FSE_REPORT,  // FSE_EXCHANGE,
		FSE_IGNORE,  // FSE_FINDER_INFO_CHANGED,
		FSE_REPORT,  // FSE_CREATE_DIR,
		FSE_IGNORE,  // FSE_CHOWN,
		FSE_IGNORE,  // FSE_XATTR_MODIFIED,
		FSE_IGNORE,  // FSE_XATTR_REMOVED,
	};
	
	// Set output streams to unbuffered
	setbuf(stdout, NULL);
	setbuf(stderr, NULL);
	
	// Open device
	fsedev_desc = open("/dev/fsevents", O_RDONLY);
	
	if (fsedev_desc < 0) {
		fprintf(stderr, "Error at open /dev/fsevents\n");
		switch (errno) {
			default:
				return 1;
				break;
		}
	}
	
	// Clone device
	clone_args.event_list = (int8_t *)clone_event_list;
	clone_args.num_events = sizeof(clone_event_list)/sizeof(int8_t);
	clone_args.event_queue_depth = QUEUE_SIZE;
	clone_args.fd = &fsedd_clone;
	
	if (ioctl(fsedev_desc, FSEVENTS_CLONE, (char *)&clone_args) < 0) {
		fprintf(stderr, "Error at ioctl FSEVENTS_CLONE\n");
		switch (errno) {
			default:
				return 1;
				break;
		}
	}
	
	// Close the data stream for the cloned descriptor
	close(fsedev_desc);
	
	// Request file system events from the device
	if (ioctl((int)fsedd_clone, FSEVENTS_WANT_EXTENDED_INFO, NULL)) {
		fprintf(stderr, "Error at ioctl FSEVENTS_WANT_EXTENDED_INFO\n");
		switch (errno) {
			default:
				return 1;
				break;
		}
	}
	
	while (run) {
		bytes_read = read(fsedd_clone, buffer, sizeof(buffer));
		
		if (bytes_read < 0) {
			switch (errno) {
				case EAGAIN:
					// Nothing read
					break;
				default:
					fprintf(stderr, "Error at read /dev/fsevents\n");
					return 1;
					break;
			}
		}
		
		for (fse_ptr_offset = 0; fse_ptr_offset < bytes_read; fse_ptr_offset += handle_event((fs_event_t *)((char *)buffer + fse_ptr_offset)));
		
		run = (read(fileno(stdin), inbuffer, sizeof(inbuffer)) < 0);
	}
	
	return 0;
}

int handle_event(fs_event_t * event) {
	int size = 0;
	
	fprintf(stdout, "<dict>\n\t<key>Type</key>\n\t<integer>%d</integer>\n\t<key>PID</key>\n\t<integer>%d</integer>\n\t<key>Args</key>\n\t<array>\n", event->type, event->procid);
	
	switch (event->type & FSE_TYPE_MASK) {
		default:
			break;
	}
	
	size += sizeof(event->type);
	size += sizeof(event->procid);
	size += handle_args(event->arguments);
	
	fprintf(stdout, "\t</array>\n</dict>\n");
	
	return size;
}

// ¿Porque?
char * fix_str(char * str, int len) {
	if (strlen(str) + 1 < len) {
		return (str + strlen(str) - (len - 1));
	} else {
		return str;
	}
}

int handle_args(fs_event_arg_t * arg) {
	int size = 0;
	
	fprintf(stdout, "\t\t<dict>\n\t\t\t<key>Type</key>\n\t\t\t<integer>%d</integer>\n\t\t\t<key>Length</key>\n\t\t\t<integer>%d</integer>\n", arg->type, arg->length);
	
	if (arg->type == FSE_ARG_DONE) {
		fprintf(stdout, "\t\t</dict>\n");
		return sizeof(arg->type);
	}
	
	switch (arg->type) {
		case FSE_ARG_STRING:
//			fprintf(stdout, "\tString: %s\n", fix_str((char *)&arg->data.string, arg->length)); // Works
			fprintf(stdout, "\t\t\t<key>Value</key>\n\t\t\t<string>%s</string>\n", ((char *)&arg->length + sizeof(arg->length)));
			break;
		default:
			break;
	}
	
	fprintf(stdout, "\t\t</dict>\n");
	
	size += sizeof(arg->type);
	size += sizeof(arg->length);
	size += arg->length;
	size += handle_args((fs_event_arg_t *)((char *)arg + size));
	
	return size;
}
