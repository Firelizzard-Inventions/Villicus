#import <Foundation/Foundation.h>
#include <sys/fsevents.h>

#pragma mark Macro Definitions

#define BUFFER_SIZE		131072
#define QUEUE_SIZE		4096
#define NUM_EVENT_ARGS	FSE_MAX_ARGS

#pragma mark -
#pragma mark Type Definitions

typedef int file_desc_t;

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
	fs_event_arg_t	arguments[NUM_EVENT_ARGS];
} fs_event_t;

#pragma mark -
#pragma mark Auxiliary Functions

#pragma mark -
#pragma mark Main Function

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

    // insert code here...
    NSLog(@"Hello, World!");
    [pool drain];
    return 0;
}
