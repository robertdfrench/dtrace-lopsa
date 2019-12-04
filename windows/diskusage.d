/*
* CDDL HEADER START
*
* The contents of this file are subject to the terms of the
* Common Development and Distribution License (the "License").
* You may not use this file except in compliance with the License.
*
* You can obtain a copy of the license at usr/src/OPENSOLARIS.LICENSE
* or http://www.opensolaris.org/os/licensing.
* See the License for the specific language governing permissions
* and limitations under the License.
*
* When distributing Covered Code, include this CDDL HEADER in each
* file and include the License file at usr/src/OPENSOLARIS.LICENSE.
* If applicable, add the following below this CDDL HEADER, with the
* fields enclosed by brackets "[]" replaced with your own identifying
* information: Portions Copyright [yyyy] [name of copyright owner]
*
* CDDL HEADER END
*/

/*++

Copyright (c) Microsoft Corporation

Module Name:

    diskusagebyexecname.d

Abstract:

    This script provides the disk counters for a given execname. The execname is case sensitive.

Requirements: 

    This script needs symbol's to be configured.

Usage: 

     dtrace -s diskusagebyexecname.d <execname>     

--*/




#pragma D option quiet
#pragma D option destructive

intptr_t curptr;
struct nt`_EPROCESS *eprocess_ptr;
int found;
int firstpass;

BEGIN
{
	curptr = (intptr_t) ((struct nt`_LIST_ENTRY *) (void*)&nt`PsActiveProcessHead)->Flink;	
	found = 0;
	firstpass = 1;
	bytesread = 0;
	byteswrite = 0;
	readcount = 0;
	writecount = 0;
	flushcount = 0;
}

tick-1ms
/found == 0/
{
/* use this for pointer parsing */

	if (found == 0)
	{
		eprocess_ptr = (struct nt`_EPROCESS *)(curptr - offsetof(nt`_EPROCESS, ActiveProcessLinks));
		processid = (string) eprocess_ptr->ImageFileName;


		if ($$1 == processid)
		{
			found = 1;
		}
		else 
		{
			curptr = (intptr_t) ((struct nt`_LIST_ENTRY *) (void*)curptr)->Flink;
		}
	}		
	
}


tick-2s
{
	if (found == 1)
	{
		if (firstpass)
		{
			firstpass = 0;
			bytesread = (unsigned long long) eprocess_ptr->DiskCounters->BytesRead;
			byteswrite = (unsigned long long) eprocess_ptr->DiskCounters->BytesWritten;
			printf("PROCNAME\tBYTES_IN\tBYTES_OUT\n");
		}
		else
		{
			printf("%s\t", eprocess_ptr->ImageFileName);
			printf("%llu\t",  (unsigned long long) bytesread);
			printf("%llu\n", (unsigned long long) byteswrite);
			
			bytesread = (unsigned long long) eprocess_ptr->DiskCounters->BytesRead;
			byteswrite = (unsigned long long) eprocess_ptr->DiskCounters->BytesWritten;
		}		
	}
	else
	{
		printf("No matching process found for %s \n", $$1);
		exit(0);
	}

}
