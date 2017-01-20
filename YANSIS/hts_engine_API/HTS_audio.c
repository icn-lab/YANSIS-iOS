/* ----------------------------------------------------------------- */
/*           The HMM-Based Speech Synthesis Engine "hts_engine API"  */
/*           developed by HTS Working Group                          */
/*           http://hts-engine.sourceforge.net/                      */
/* ----------------------------------------------------------------- */
/*                                                                   */
/*  Copyright (c) 2001-2015  Nagoya Institute of Technology          */
/*                           Department of Computer Science          */
/*                                                                   */
/*                2001-2008  Tokyo Institute of Technology           */
/*                           Interdisciplinary Graduate School of    */
/*                           Science and Engineering                 */
/*                                                                   */
/* All rights reserved.                                              */
/*                                                                   */
/* Redistribution and use in source and binary forms, with or        */
/* without modification, are permitted provided that the following   */
/* conditions are met:                                               */
/*                                                                   */
/* - Redistributions of source code must retain the above copyright  */
/*   notice, this list of conditions and the following disclaimer.   */
/* - Redistributions in binary form must reproduce the above         */
/*   copyright notice, this list of conditions and the following     */
/*   disclaimer in the documentation and/or other materials provided */
/*   with the distribution.                                          */
/* - Neither the name of the HTS working group nor the names of its  */
/*   contributors may be used to endorse or promote products derived */
/*   from this software without specific prior written permission.   */
/*                                                                   */
/* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND            */
/* CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,       */
/* INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF          */
/* MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE          */
/* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS */
/* BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,          */
/* EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED   */
/* TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,     */
/* DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON */
/* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,   */
/* OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY    */
/* OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE           */
/* POSSIBILITY OF SUCH DAMAGE.                                       */
/* ----------------------------------------------------------------- */

#ifndef HTS_AUDIO_C
#define HTS_AUDIO_C

/* hts_engine libralies */
#include "HTS_hidden.h"

/* HTS_Audio_initialize: initialize audio */
void HTS_Audio_initialize(HTS_Audio * audio)
{
    if (audio == NULL)
        return;
    
    audio->sampling_frequency = 0;
    audio->max_buff_size = 0;
    audio->buff = NULL;
    audio->buff_size = 0;
}

/* HTS_Audio_set_parameter: set parameters for audio */
void HTS_Audio_set_parameter(HTS_Audio * audio, size_t sampling_frequency, size_t max_buff_size)
{
    if (audio == NULL)
        return;
    
    if (audio->sampling_frequency == sampling_frequency && audio->max_buff_size == max_buff_size)
        return;
    
    HTS_Audio_clear(audio);
    
    if (sampling_frequency == 0 || max_buff_size == 0)
        return;
    
    audio->sampling_frequency = sampling_frequency;
    audio->max_buff_size = max_buff_size;
    audio->buff = (short *) HTS_calloc(max_buff_size, sizeof(short));
    audio->buff_size = 0;
}

/* HTS_Audio_write: send data to audio */
void HTS_Audio_write(HTS_Audio * audio, short data)
{
    if (audio == NULL)
        return;
    
    int cur = (audio->buff_size++) % audio->max_buff_size;
    audio->buff[cur] = data;
}

void HTS_Audio_read(HTS_Audio *audio, short *sbuf, int *nData, int pos)
{
    if (audio == NULL)
        return;
    
    if (*nData > audio->buff_size - pos)
        *nData = audio->buff_size - pos;
    
    for (int i=0;i < *nData;i++)
    {
        sbuf[i] = audio->buff[(pos+i) % audio->max_buff_size];
    }
    //fprintf(stderr, "read: %d\n", *nData);
}

int HTS_Audio_end_playing(HTS_Audio *audio, int pos){
    if(pos == audio->buff_size)
        return 1;
    
    return 0;
}

/* HTS_Audio_flush: flush remain data */
void HTS_Audio_flush(HTS_Audio * audio)
{
}

void HTS_Audio_refresh(HTS_Audio *audio)
{
    if(audio == NULL)
        return;
    
    audio->buff_size = 0;
}

/* HTS_Audio_clear: free audio */
void HTS_Audio_clear(HTS_Audio * audio)
{
    if (audio == NULL)
        return;
    
    if (audio->buff != NULL)
        free(audio->buff);
    HTS_Audio_initialize(audio);
}


#endif                          /* !HTS_AUDIO_C */
