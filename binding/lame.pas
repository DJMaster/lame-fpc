//
// lame.h header binding for the Free Pascal Compiler aka FPC
//
// Binaries and demos available at http://www.djmaster.com/
//

(*
 *	Interface to MP3 LAME encoding engine
 *
 *	Copyright (c) 1999 Mark Taylor
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 *)

(* $Id: lame.h,v 1.192 2017/08/31 14:14:46 robert Exp $ *)

unit lame;

{$mode objfpc}{$H+}

interface

uses
  ctypes;

const
  LIB_LAME = 'libmp3lame-0.dll';

// (* for size_t typedef *)
// #include <stddef.h>
// (* for va_list typedef *)
// #include <stdarg.h>
// (* for FILE typedef, TODO: remove when removing lame_mp3_tags_fid *)
// #include <stdio.h>

type
  lame_report_function = procedure (const format: pcchar); cdecl; varargs;

{$define DEPRECATED_OR_OBSOLETE_CODE_REMOVED}

type
  vbr_mode = (
    vbr_off = 0,
    vbr_mt, (* obsolete, same as vbr_mtrh *)
    vbr_rh,
    vbr_abr,
    vbr_mtrh,
    vbr_max_indicator (* Don't use this! It's used for sanity checks. *)
  );

const
  vbr_default = vbr_mtrh; (* change this to change the default VBR mode of LAME *)


type
(* MPEG modes *)
  MPEG_mode = (
    STEREO = 0,
    JOINT_STEREO,
    DUAL_CHANNEL, (* LAME doesn't supports this! *)
    MONO,
    NOT_SET,
    MAX_INDICATOR (* Don't use this! It's used for sanity checks. *)
  );

(* Padding types *)
  Padding_type = (
    PAD_NO = 0,
    PAD_ALL,
    PAD_ADJUST,
    PAD_MAX_INDICATOR (* Don't use this! It's used for sanity checks. *)
  );

(* presets *)
  preset_mode = (
    (* values from 8 to 320 should be reserved for abr bitrates *)
    (* for abr I'd suggest to directly use the targeted bitrate as a value *)
    ABR_8 = 8,
    ABR_320 = 320,

    V9 = 410, (* Vx to match Lame and VBR_xx to match FhG *)
    V8 = 420,
    V7 = 430,
    V6 = 440,
    V5 = 450,
    V4 = 460,
    V3 = 470,
    V2 = 480,
    V1 = 490,
    V0 = 500,

    (* still there for compatibility *)
    R3MIX = 1000,
    STANDARD = 1001,
    EXTREME = 1002,
    INSANE = 1003,
    STANDARD_FAST = 1004,
    EXTREME_FAST = 1005,
    MEDIUM = 1006,
    MEDIUM_FAST = 1007
  );

const
  VBR_10 = 410;
  VBR_20 = 420;
  VBR_30 = 430;
  VBR_40 = 440;
  VBR_50 = 450;
  VBR_60 = 460;
  VBR_70 = 470;
  VBR_80 = 480;
  VBR_90 = 490;
  VBR_100 = 500;

type
(* asm optimizations *)
  asm_optimizations = (
    MMX = 1,
    AMD_3DNOW = 2,
    SSE = 3
  );

(* psychoacoustic model *)
  Psy_model = (
    PSY_GPSYCHO = 1,
    PSY_NSPSYTUNE = 2
  );

(* buffer considerations *)
  buffer_constraint = (
    MDB_DEFAULT = 0,
    MDB_STRICT_ISO = 1,
    MDB_MAXIMUM = 2
  );

  lame_global_struct = record
  end;

  lame_global_flags = lame_global_struct;

  lame_t = pointer;
  Plame_global_flags = lame_t;

(***********************************************************************
 *
 *  The LAME API
 *  These functions should be called, in this order, for each
 *  MP3 file to be encoded.  See the file "API" for more documentation
 *
 ***********************************************************************)

(*
 * REQUIRED:
 * initialize the encoder.  sets default for all encoder parameters,
 * returns NULL if some malloc()'s failed
 * otherwise returns pointer to structure needed for all future
 * API calls.
 *)
function lame_init(): Plame_global_flags; cdecl; external LIB_LAME;
{$ifdef DEPRECATED_OR_OBSOLETE_CODE_REMOVED}
{$else}
(* obsolete version *)
function lame_init_old(gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;
{$endif}

(*
 * OPTIONAL:
 * set as needed to override defaults
 *)

(********************************************************************
 *  input stream description
 ***********************************************************************)
(* number of samples.  default = 2^32-1 *)
function lame_set_num_samples(gfp: Plame_global_flags; num_samples: culong): cint; cdecl; external LIB_LAME;
function lame_get_num_samples(const gfp: Plame_global_flags): culong; cdecl; external LIB_LAME;

(* input sample rate in Hz.  default = 44100hz *)
function lame_set_in_samplerate(gfp: Plame_global_flags; in_samplerate: cint): cint; cdecl; external LIB_LAME;
function lame_get_in_samplerate(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

(* number of channels in input stream. default=2 *)
function lame_set_num_channels(gfp: Plame_global_flags; num_channels: cint): cint; cdecl; external LIB_LAME;
function lame_get_num_channels(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

(*
  scale the input by this amount before encoding.  default=1
  (not used by decoding routines)
*)
function lame_set_scale(gfp: Plame_global_flags; scale: cfloat): cint; cdecl; external LIB_LAME;
function lame_get_scale(const gfp: Plame_global_flags): cfloat; cdecl; external LIB_LAME;

(*
  scale the channel 0 (left) input by this amount before encoding.  default=1
  (not used by decoding routines)
*)
function lame_set_scale_left(gfp: Plame_global_flags; scale_left: cfloat): cint; cdecl; external LIB_LAME;
function lame_get_scale_left(const gfp: Plame_global_flags): cfloat; cdecl; external LIB_LAME;

(*
  scale the channel 1 (right) input by this amount before encoding.  default=1
  (not used by decoding routines)
*)
function lame_set_scale_right(gfp: Plame_global_flags; scale_right: cfloat): cint; cdecl; external LIB_LAME;
function lame_get_scale_right(const gfp: Plame_global_flags): cfloat; cdecl; external LIB_LAME;

(*
  output sample rate in Hz.  default = 0, which means LAME picks best value
  based on the amount of compression.  MPEG only allows:
  MPEG1    32, 44.1,   48khz
  MPEG2    16, 22.05,  24
  MPEG2.5   8, 11.025, 12
  (not used by decoding routines)
*)
function lame_set_out_samplerate(gfp: Plame_global_flags; out_samplerate: cint): cint; cdecl; external LIB_LAME;
function lame_get_out_samplerate(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

(********************************************************************
 *  general control parameters
 ***********************************************************************)
(* 1=cause LAME to collect data for an MP3 frame analyzer. default=0 *)
function lame_set_analysis(gfp: Plame_global_flags; analysis: cint): cint; cdecl; external LIB_LAME;
function lame_get_analysis(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

(*
  1 = write a Xing VBR header frame.
  default = 1
  this variable must have been added by a Hungarian notation Windows programmer :-)
*)
function lame_set_bWriteVbrTag(gfp: Plame_global_flags; bWriteVbrTag: cint): cint; cdecl; external LIB_LAME;
function lame_get_bWriteVbrTag(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

(* 1=decode only.  use lame/mpglib to convert mp3/ogg to wav.  default=0 *)
function lame_set_decode_only(gfp: Plame_global_flags; decode_only: cint): cint; cdecl; external LIB_LAME;
function lame_get_decode_only(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

{$ifdef DEPRECATED_OR_OBSOLETE_CODE_REMOVED}
{$else}
(* 1=encode a Vorbis .ogg file.  default=0 *)
(* DEPRECATED *)
function lame_set_ogg(gfp: Plame_global_flags; ogg: cint): cint; cdecl; external LIB_LAME;
function lame_get_ogg(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;
{$endif}

(*
  internal algorithm selection.  True quality is determined by the bitrate
  but this variable will effect quality by selecting expensive or cheap algorithms.
  quality=0..9.  0=best (very slow).  9=worst.
  recommended:  2     near-best quality, not too slow
                5     good quality, fast
                7     ok quality, really fast
*)
function lame_set_quality(gfp: Plame_global_flags; quality: cint): cint; cdecl; external LIB_LAME;
function lame_get_quality(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

(*
  mode = 0,1,2,3 = stereo, jstereo, dual channel (not supported), mono
  default: lame picks based on compression ration and input channels
*)
function lame_set_mode(gfp: Plame_global_flags; mode: MPEG_mode): cint; cdecl; external LIB_LAME;
function lame_get_mode(const gfp: Plame_global_flags): MPEG_mode; cdecl; external LIB_LAME;

{$ifdef DEPRECATED_OR_OBSOLETE_CODE_REMOVED}
{$else}
(*
  mode_automs.  Use a M/S mode with a switching threshold based on
  compression ratio
  DEPRECATED
*)
function lame_set_mode_automs(gfp: Plame_global_flags; mode_automs: cint): cint; cdecl; external LIB_LAME;
function lame_get_mode_automs(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;
{$endif}

(*
  force_ms.  Force M/S for all frames.  For testing only.
  default = 0 (disabled)
*)
function lame_set_force_ms(gfp: Plame_global_flags; force_ms: cint): cint; cdecl; external LIB_LAME;
function lame_get_force_ms(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

(* use free_format?  default = 0 (disabled) *)
function lame_set_free_format(gfp: Plame_global_flags; free_format: cint): cint; cdecl; external LIB_LAME;
function lame_get_free_format(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

(* perform ReplayGain analysis?  default = 0 (disabled) *)
function lame_set_findReplayGain(gfp: Plame_global_flags; findReplayGain: cint): cint; cdecl; external LIB_LAME;
function lame_get_findReplayGain(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

(* decode on the fly. Search for the peak sample. If the ReplayGain
 * analysis is enabled then perform the analysis on the decoded data
 * stream. default = 0 (disabled)
 * NOTE: if this option is set the build-in decoder should not be used *)
function lame_set_decode_on_the_fly(gfp: Plame_global_flags; decode_on_the_fly: cint): cint; cdecl; external LIB_LAME;
function lame_get_decode_on_the_fly(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

{$ifdef DEPRECATED_OR_OBSOLETE_CODE_REMOVED}
{$else}
(* DEPRECATED: now does the same as lame_set_findReplayGain()
   default = 0 (disabled) *)
function lame_set_ReplayGain_input(gfp: Plame_global_flags; ReplayGain_input: cint): cint; cdecl; external LIB_LAME;
function lame_get_ReplayGain_input(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

(* DEPRECATED: now does the same as
   lame_set_decode_on_the_fly() && lame_set_findReplayGain()
   default = 0 (disabled) *)
function lame_set_ReplayGain_decode(gfp: Plame_global_flags; ReplayGain_decode: cint): cint; cdecl; external LIB_LAME;
function lame_get_ReplayGain_decode(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

(* DEPRECATED: now does the same as lame_set_decode_on_the_fly()
   default = 0 (disabled) *)
function lame_set_findPeakSample(gfp: Plame_global_flags; findPeakSample: cint): cint; cdecl; external LIB_LAME;
function lame_get_findPeakSample(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;
{$endif}

(* counters for gapless encoding *)
function lame_set_nogap_total(gfp: Plame_global_flags; nogap_total: cint): cint; cdecl; external LIB_LAME;
function lame_get_nogap_total(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

function lame_set_nogap_currentindex(gfp: Plame_global_flags; nogap_currentindex: cint): cint; cdecl; external LIB_LAME;
function lame_get_nogap_currentindex(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

(*
 * OPTIONAL:
 * Set printf like error/debug/message reporting functions.
 * The second argument has to be a pointer to a function which looks like
 *   void my_debugf(const char *format, va_list ap)
 *   {
 *       (void) vfprintf(stdout, format, ap);
 *   }
 * If you use NULL as the value of the pointer in the set function, the
 * lame buildin function will be used (prints to stderr).
 * To quiet any output you have to replace the body of the example function
 * with just "return;" and use it in the set function.
 *)
function lame_set_errorf(gfp: Plame_global_flags; errorf: lame_report_function): cint; cdecl; external LIB_LAME;
function lame_set_debugf(gfp: Plame_global_flags; debugf: lame_report_function): cint; cdecl; external LIB_LAME;
function lame_set_msgf(gfp: Plame_global_flags; msgf: lame_report_function): cint; cdecl; external LIB_LAME;

(* set one of brate compression ratio.  default is compression ratio of 11. *)
function lame_set_brate(gfp: Plame_global_flags; brate: cint): cint; cdecl; external LIB_LAME;
function lame_get_brate(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;
function lame_set_compression_ratio(gfp: Plame_global_flags; compression_ratio: cfloat): cint; cdecl; external LIB_LAME;
function lame_get_compression_ratio(const gfp: Plame_global_flags): cfloat; cdecl; external LIB_LAME;

function lame_set_preset(gfp: Plame_global_flags; preset: cint): cint; cdecl; external LIB_LAME;
function lame_set_asm_optimizations(gfp: Plame_global_flags; asm_optimizations1: cint; asm_optimizations2: cint): cint; cdecl; external LIB_LAME;

(********************************************************************
 *  frame params
 ***********************************************************************)
(* mark as copyright.  default=0 *)
function lame_set_copyright(gfp: Plame_global_flags; copyright: cint): cint; cdecl; external LIB_LAME;
function lame_get_copyright(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

(* mark as original.  default=1 *)
function lame_set_original(gfp: Plame_global_flags; original: cint): cint; cdecl; external LIB_LAME;
function lame_get_original(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

(* error_protection.  Use 2 bytes from each frame for CRC checksum. default=0 *)
function lame_set_error_protection(gfp: Plame_global_flags; error_protection: cint): cint; cdecl; external LIB_LAME;
function lame_get_error_protection(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

{$ifdef DEPRECATED_OR_OBSOLETE_CODE_REMOVED}
{$else}
(* padding_type. 0=pad no frames  1=pad all frames 2=adjust padding(default) *)
function lame_set_padding_type(gfp: Plame_global_flags; padding: Padding_type): cint; cdecl; external LIB_LAME;
function lame_get_padding_type(const gfp: Plame_global_flags): Padding_type; cdecl; external LIB_LAME;
{$endif}

(* MP3 'private extension' bit  Meaningless.  default=0 *)
function lame_set_extension(gfp: Plame_global_flags; extension: cint): cint; cdecl; external LIB_LAME;
function lame_get_extension(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

(* enforce strict ISO compliance.  default=0 *)
function lame_set_strict_ISO(gfp: Plame_global_flags; strict_ISO: cint): cint; cdecl; external LIB_LAME;
function lame_get_strict_ISO(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

(********************************************************************
 * quantization/noise shaping
 ***********************************************************************)

(* disable the bit reservoir. For testing only. default=0 *)
function lame_set_disable_reservoir(gfp: Plame_global_flags; disable_reservoir: cint): cint; cdecl; external LIB_LAME;
function lame_get_disable_reservoir(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

(* select a different "best quantization" function. default=0 *)
function lame_set_quant_comp(gfp: Plame_global_flags; quant_comp: cint): cint; cdecl; external LIB_LAME;
function lame_get_quant_comp(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;
function lame_set_quant_comp_short(gfp: Plame_global_flags; quant_comp_short: cint): cint; cdecl; external LIB_LAME;
function lame_get_quant_comp_short(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

function lame_set_experimentalX(gfp: Plame_global_flags; experimentalX: cint): cint; cdecl; external LIB_LAME; (* compatibility*)
function lame_get_experimentalX(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

(* another experimental option.  for testing only *)
function lame_set_experimentalY(gfp: Plame_global_flags; experimentalY: cint): cint; cdecl; external LIB_LAME;
function lame_get_experimentalY(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

(* another experimental option.  for testing only *)
function lame_set_experimentalZ(gfp: Plame_global_flags; experimentalZ: cint): cint; cdecl; external LIB_LAME;
function lame_get_experimentalZ(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

(* Naoki's psycho acoustic model.  default=0 *)
function lame_set_exp_nspsytune(gfp: Plame_global_flags; exp_nspsytune: cint): cint; cdecl; external LIB_LAME;
function lame_get_exp_nspsytune(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

procedure lame_set_msfix(gfp: Plame_global_flags; msfix: cdouble); cdecl; external LIB_LAME;
function lame_get_msfix(const gfp: Plame_global_flags): cfloat; cdecl; external LIB_LAME;

(********************************************************************
 * VBR control
 ***********************************************************************)
(* Types of VBR.  default = vbr_off = CBR *)
function lame_set_VBR(gfp: Plame_global_flags; VBR: vbr_mode): cint; cdecl; external LIB_LAME;
function lame_get_VBR(const gfp: Plame_global_flags): vbr_mode; cdecl; external LIB_LAME;

(* VBR quality level.  0=highest  9=lowest *)
function lame_set_VBR_q(gfp: Plame_global_flags; VBR_q: cint): cint; cdecl; external LIB_LAME;
function lame_get_VBR_q(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

(* VBR quality level.  0=highest  9=lowest, Range [0,...,10] *)
function lame_set_VBR_quality(gfp: Plame_global_flags; VBR_quality: cfloat): cint; cdecl; external LIB_LAME;
function lame_get_VBR_quality(const gfp: Plame_global_flags): cfloat; cdecl; external LIB_LAME;

(* Ignored except for VBR=vbr_abr (ABR mode) *)
function lame_set_VBR_mean_bitrate_kbps(gfp: Plame_global_flags; VBR_mean_bitrate_kbps: cint): cint; cdecl; external LIB_LAME;
function lame_get_VBR_mean_bitrate_kbps(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

function lame_set_VBR_min_bitrate_kbps(gfp: Plame_global_flags; VBR_min_bitrate_kbps: cint): cint; cdecl; external LIB_LAME;
function lame_get_VBR_min_bitrate_kbps(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

function lame_set_VBR_max_bitrate_kbps(gfp: Plame_global_flags; VBR_max_bitrate_kbps: cint): cint; cdecl; external LIB_LAME;
function lame_get_VBR_max_bitrate_kbps(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

(*
  1=strictly enforce VBR_min_bitrate.  Normally it will be violated for
  analog silence
*)
function lame_set_VBR_hard_min(gfp: Plame_global_flags; VBR_hard_min: cint): cint; cdecl; external LIB_LAME;
function lame_get_VBR_hard_min(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

(* for preset *)
{$ifdef DEPRECATED_OR_OBSOLETE_CODE_REMOVED}
{$else}
function lame_set_preset_expopts(gfp: Plame_global_flags; preset_expopts: cint): cint; cdecl; external LIB_LAME;
{$endif}

(********************************************************************
 * Filtering control
 ***********************************************************************)
(* freq in Hz to apply lowpass. Default = 0 = lame chooses.  -1 = disabled *)
function lame_set_lowpassfreq(gfp: Plame_global_flags; lowpassfreq: cint): cint; cdecl; external LIB_LAME;
function lame_get_lowpassfreq(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;
(* width of transition band, in Hz.  Default = one polyphase filter band *)
function lame_set_lowpasswidth(gfp: Plame_global_flags; lowpasswidth: cint): cint; cdecl; external LIB_LAME;
function lame_get_lowpasswidth(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

(* freq in Hz to apply highpass. Default = 0 = lame chooses.  -1 = disabled *)
function lame_set_highpassfreq(gfp: Plame_global_flags; highpassfreq: cint): cint; cdecl; external LIB_LAME;
function lame_get_highpassfreq(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;
(* width of transition band, in Hz.  Default = one polyphase filter band *)
function lame_set_highpasswidth(gfp: Plame_global_flags; highpasswidth: cint): cint; cdecl; external LIB_LAME;
function lame_get_highpasswidth(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

(********************************************************************
 * psycho acoustics and other arguments which you should not change
 * unless you know what you are doing
 ***********************************************************************)

(* only use ATH for masking *)
function lame_set_ATHonly(gfp: Plame_global_flags; ATHonly: cint): cint; cdecl; external LIB_LAME;
function lame_get_ATHonly(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

(* only use ATH for short blocks *)
function lame_set_ATHshort(gfp: Plame_global_flags; ATHshort: cint): cint; cdecl; external LIB_LAME;
function lame_get_ATHshort(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

(* disable ATH *)
function lame_set_noATH(gfp: Plame_global_flags; noATH: cint): cint; cdecl; external LIB_LAME;
function lame_get_noATH(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

(* select ATH formula *)
function lame_set_ATHtype(gfp: Plame_global_flags; ATHtype: cint): cint; cdecl; external LIB_LAME;
function lame_get_ATHtype(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

(* lower ATH by this many db *)
function lame_set_ATHlower(gfp: Plame_global_flags; ATHlower: cfloat): cint; cdecl; external LIB_LAME;
function lame_get_ATHlower(const gfp: Plame_global_flags): cfloat; cdecl; external LIB_LAME;

(* select ATH adaptive adjustment type *)
function lame_set_athaa_type(gfp: Plame_global_flags; athaa_type: cint): cint; cdecl; external LIB_LAME;
function lame_get_athaa_type(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

{$ifdef DEPRECATED_OR_OBSOLETE_CODE_REMOVED}
{$else}
(* select the loudness approximation used by the ATH adaptive auto-leveling *)
function lame_set_athaa_loudapprox(gfp: Plame_global_flags; athaa_loudapprox: cint): cint; cdecl; external LIB_LAME;
function lame_get_athaa_loudapprox(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;
{$endif}

(* adjust (in dB) the point below which adaptive ATH level adjustment occurs *)
function lame_set_athaa_sensitivity(gfp: Plame_global_flags; athaa_sensitivity: cfloat): cint; cdecl; external LIB_LAME;
function lame_get_athaa_sensitivity(const gfp: Plame_global_flags): cfloat; cdecl; external LIB_LAME;

{$ifdef DEPRECATED_OR_OBSOLETE_CODE_REMOVED}
{$else}
(* OBSOLETE: predictability limit (ISO tonality formula) *)
function lame_set_cwlimit(gfp: Plame_global_flags; cwlimit: cint): cint; cdecl; external LIB_LAME;
function lame_get_cwlimit(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;
{$endif}

(*
  allow blocktypes to differ between channels?
  default: 0 for jstereo, 1 for stereo
*)
function lame_set_allow_diff_short(gfp: Plame_global_flags; allow_diff_short: cint): cint; cdecl; external LIB_LAME;
function lame_get_allow_diff_short(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

(* use temporal masking effect (default = 1) *)
function lame_set_useTemporal(gfp: Plame_global_flags; useTemporal: cint): cint; cdecl; external LIB_LAME;
function lame_get_useTemporal(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

(* use temporal masking effect (default = 1) *)
function lame_set_interChRatio(gfp: Plame_global_flags; interChRatio: cfloat): cint; cdecl; external LIB_LAME;
function lame_get_interChRatio(const gfp: Plame_global_flags): cfloat; cdecl; external LIB_LAME;

(* disable short blocks *)
function lame_set_no_short_blocks(gfp: Plame_global_flags; no_short_blocks: cint): cint; cdecl; external LIB_LAME;
function lame_get_no_short_blocks(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

(* force short blocks *)
function lame_set_force_short_blocks(gfp: Plame_global_flags; force_short_blocks: cint): cint; cdecl; external LIB_LAME;
function lame_get_force_short_blocks(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

(* Input PCM is emphased PCM (for instance from one of the rarely
   emphased CDs), it is STRONGLY not recommended to use this, because
   psycho does not take it into account, and last but not least many decoders
   ignore these bits *)
function lame_set_emphasis(gfp: Plame_global_flags; emphasis: cint): cint; cdecl; external LIB_LAME;
function lame_get_emphasis(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

(************************************************************************)
(* internal variables, cannot be set...                                 *)
(* provided because they may be of use to calling application           *)
(************************************************************************)
(* version  0=MPEG-2  1=MPEG-1  (2=MPEG-2.5) *)
function lame_get_version(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

(* encoder delay *)
function lame_get_encoder_delay(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

(*
  padding appended to the input to make sure decoder can fully decode
  all input.  Note that this value can only be calculated during the
  call to lame_encoder_flush().  Before lame_encoder_flush() has
  been called, the value of encoder_padding = 0.
*)
function lame_get_encoder_padding(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

(* size of MPEG frame *)
function lame_get_framesize(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

(* number of PCM samples buffered, but not yet encoded to mp3 data. *)
function lame_get_mf_samples_to_encode(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

(*
  size (bytes) of mp3 data buffered, but not yet encoded.
  this is the number of bytes which would be output by a call to
  lame_encode_flush_nogap.  NOTE: lame_encode_flush() will return
  more bytes than this because it will encode the reamining buffered
  PCM samples before flushing the mp3 buffers.
*)
function lame_get_size_mp3buffer(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

(* number of frames encoded so far *)
function lame_get_frameNum(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

(*
  lame's estimate of the total number of frames to be encoded
   only valid if calling program set num_samples
*)
function lame_get_totalframes(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

(* RadioGain value. Multiplied by 10 and rounded to the nearest. *)
function lame_get_RadioGain(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

(* AudiophileGain value. Multipled by 10 and rounded to the nearest. *)
function lame_get_AudiophileGain(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

(* the peak sample *)
function lame_get_PeakSample(const gfp: Plame_global_flags): cfloat; cdecl; external LIB_LAME;

(* Gain change required for preventing clipping. The value is correct only if
   peak sample searching was enabled. If negative then the waveform
   already does not clip. The value is multiplied by 10 and rounded up. *)
function lame_get_noclipGainChange(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

(* user-specified scale factor required for preventing clipping. Value is
   correct only if peak sample searching was enabled and no user-specified
   scaling was performed. If negative then either the waveform already does
   not clip or the value cannot be determined *)
function lame_get_noclipScale(const gfp: Plame_global_flags): cfloat; cdecl; external LIB_LAME;

(* returns the limit of PCM samples, which one can pass in an encode call
   under the constrain of a provided buffer of size buffer_size *)
function lame_get_maximum_number_of_samples(gfp: lame_t; buffer_size: csize_t): cint; cdecl; external LIB_LAME;

(*
 * REQUIRED:
 * sets more internal configuration based on data provided above.
 * returns -1 if something failed.
 *)
function lame_init_params(gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

(*
 * OPTIONAL:
 * get the version number, in a string. of the form:
 * "3.63 (beta)" or just "3.63".
 *)
function get_lame_version(): pchar; cdecl; external LIB_LAME;
function get_lame_short_version(): pchar; cdecl; external LIB_LAME;
function get_lame_very_short_version(): pchar; cdecl; external LIB_LAME;
function get_psy_version(): pchar; cdecl; external LIB_LAME;
function get_lame_url(): pchar; cdecl; external LIB_LAME;
function get_lame_os_bitness(): pchar; cdecl; external LIB_LAME;

type
(*
 * OPTIONAL:
 * get the version numbers in numerical form.
 *)
  Plame_version_t = ^lame_version_t;
  lame_version_t = record
    (* generic LAME version *)
    major: cint;
    minor: cint;
    alpha: cint; (* 0 if not an alpha version *)
    beta: cint; (* 0 if not a beta version *)

    (* version of the psy model *)
    psy_major: cint;
    psy_minor: cint;
    psy_alpha: cint; (* 0 if not an alpha version *)
    psy_beta: cint; (* 0 if not a beta version *)

    (* compile time features *)
    features: pcchar; (* Don't make assumptions about the contents! *)
  end;

procedure get_lame_version_numerical(version_t: Plame_version_t); cdecl; external LIB_LAME;

(*
 * OPTIONAL:
 * print internal lame configuration to message handler
 *)
procedure lame_print_config(const gfp: Plame_global_flags); cdecl; external LIB_LAME;

procedure lame_print_internals(const gfp: Plame_global_flags); cdecl; external LIB_LAME;

(*
 * input pcm data, output (maybe) mp3 frames.
 * This routine handles all buffering, resampling and filtering for you.
 *
 * return code     number of bytes output in mp3buf. Can be 0
 *                 -1:  mp3buf was too small
 *                 -2:  malloc() problem
 *                 -3:  lame_init_params() not called
 *                 -4:  psycho acoustic problems
 *
 * The required mp3buf_size can be computed from num_samples,
 * samplerate and encoding rate, but here is a worst case estimate:
 *
 * mp3buf_size in bytes = 1.25*num_samples + 7200
 *
 * I think a tighter bound could be:  (mt, March 2000)
 * MPEG1:
 *    num_samples*(bitrate/8)/samplerate + 4*1152*(bitrate/8)/samplerate + 512
 * MPEG2:
 *    num_samples*(bitrate/8)/samplerate + 4*576*(bitrate/8)/samplerate + 256
 *
 * but test first if you use that!
 *
 * set mp3buf_size = 0 and LAME will not check if mp3buf_size is
 * large enough.
 *
 * NOTE:
 * if gfp->num_channels=2, but gfp->mode = 3 (mono), the L & R channels
 * will be averaged into the L channel before encoding only the L channel
 * This will overwrite the data in buffer_l[] and buffer_r[].
 *
*)
function lame_encode_buffer(
        gfp: Plame_global_flags; (* global context handle *)
        const buffer_l: array of csint; (* PCM data for left channel *)
        const buffer_r: array of csint; (* PCM data for right channel *)
        const nsamples: cint; (* number of samples per channel *)
        mp3buf: pcuchar; (* pointer to encoded MP3 stream *)
        const mp3buf_size: cint (* number of valid octets in this stream *)
      ): cint; cdecl; external LIB_LAME;

(*
 * as above, but input has L & R channel data interleaved.
 * NOTE:
 * num_samples = number of samples in the L (or R)
 * channel, not the total number of samples in pcm[]
 *)
function lame_encode_buffer_interleaved(
        gfp: Plame_global_flags; (* global context handlei *)
        pcm: array of csint; (* PCM data for left and right channel, interleaved *)
        num_samples: cint; (* number of samples per channel, _not_ number of samples in pcm[] *)
        mp3buf: pcuchar; (* pointer to encoded MP3 stream *)
        mp3buf_size: cint (* number of valid octets in this stream *)
      ): cint; cdecl; external LIB_LAME;

(*
 * as above, but for interleaved data.
 * !! NOTE: !! data must still be scaled to be in the same range as
 * type 'int32_t'.   Data should be in the range:  +/- 2^(8*size(int32_t)-1)
 * NOTE:
 * num_samples = number of samples in the L (or R)
 * channel, not the total number of samples in pcm[]
 *)
function lame_encode_buffer_interleaved_int(
        gfp: lame_t;
        const pcm: array of cint; (* PCM data for left and right channel, interleaved *)
        const nsamples: cint; (* number of samples per channel, _not_ number of samples in pcm[] *)
        mp3buf: pcuchar; (* pointer to encoded MP3 stream *)
        const mp3buf_size: cint (* number of valid octets in this stream *)
      ): cint; cdecl; external LIB_LAME;

(* as lame_encode_buffer, but for 'float's.
 * !! NOTE: !! data must still be scaled to be in the same range as
 * short int, +/- 32768
 *)
function lame_encode_buffer_float(
        gfp: Plame_global_flags; (* global context handle *)
        const pcm_l: array of cfloat; (* PCM data for left channel *)
        const pcm_r: array of cfloat; (* PCM data for right channel *)
        const nsamples: cint; (* number of samples per channel *)
        mp3buf: pcuchar; (* pointer to encoded MP3 stream *)
        const mp3buf_size: cint (* number of valid octets in this stream *)
      ): cint; cdecl; external LIB_LAME;

(* as lame_encode_buffer, but for 'float's.
 * !! NOTE: !! data must be scaled to +/- 1 full scale
 *)
function lame_encode_buffer_ieee_float(
        gfp: lame_t;
        const pcm_l: array of cfloat; (* PCM data for left channel *)
        const pcm_r: array of cfloat; (* PCM data for right channel *)
        const nsamples: cint;
        mp3buf: pcuchar;
        const mp3buf_size: cint): cint; cdecl; external LIB_LAME;

function lame_encode_buffer_interleaved_ieee_float(
        gfp: lame_t;
        const pcm: array of cfloat; (* PCM data for left and right channel, interleaved *)
        const nsamples: cint;
        mp3buf: pcuchar;
        const mp3buf_size: cint): cint; cdecl; external LIB_LAME;

(* as lame_encode_buffer, but for 'double's.
 * !! NOTE: !! data must be scaled to +/- 1 full scale
 *)
function lame_encode_buffer_ieee_double(
        gfp: lame_t;
        const pcm_l: array of cdouble; (* PCM data for left channel *)
        const pcm_r: array of cdouble; (* PCM data for right channel *)
        const nsamples: cint;
        mp3buf: pcuchar;
        const mp3buf_size: cint): cint; cdecl; external LIB_LAME;

function lame_encode_buffer_interleaved_ieee_double(
        gfp: lame_t;
        const pcm: array of cdouble; (* PCM data for left and right channel, interleaved *)
        const nsamples: cint;
        mp3buf: pcuchar;
        const mp3buf_size: cint): cint; cdecl; external LIB_LAME;

(* as lame_encode_buffer, but for long's
 * !! NOTE: !! data must still be scaled to be in the same range as
 * short int, +/- 32768
 *
 * This scaling was a mistake (doesn't allow one to exploit full
 * precision of type 'long'.  Use lame_encode_buffer_long2() instead.
 *
 *)
function lame_encode_buffer_long(
        gfp: Plame_global_flags; (* global context handle *)
        const buffer_l: array of clong; (* PCM data for left channel *)
        const buffer_r: array of clong; (* PCM data for right channel *)
        const nsamples: cint; (* number of samples per channel *)
        mp3buf: pcuchar; (* pointer to encoded MP3 stream *)
        const mp3buf_size: cint
      ): cint; cdecl; external LIB_LAME; (* number of valid octets in this stream *)

(* Same as lame_encode_buffer_long(), but with correct scaling.
 * !! NOTE: !! data must still be scaled to be in the same range as
 * type 'long'.   Data should be in the range:  +/- 2^(8*size(long)-1)
 *
 *)
function lame_encode_buffer_long2(
        gfp: Plame_global_flags; (* global context handle *)
        const buffer_l: array of clong; (* PCM data for left channel *)
        const buffer_r: array of clong; (* PCM data for right channel *)
        const nsamples: cint; (* number of samples per channel *)
        mp3buf: pcuchar; (* pointer to encoded MP3 stream *)
        const mp3buf_size: cint (* number of valid octets in this stream *)
      ): cint; cdecl; external LIB_LAME;

(* as lame_encode_buffer, but for int's
 * !! NOTE: !! input should be scaled to the maximum range of 'int'
 * If int is 4 bytes, then the values should range from
 * +/- 2147483648.
 *
 * This routine does not (and cannot, without loosing precision) use
 * the same scaling as the rest of the lame_encode_buffer() routines.
 *
 *)
function lame_encode_buffer_int(
        gfp: Plame_global_flags; (* global context handle *)
        const buffer_l: array of cint; (* PCM data for left channel *)
        const buffer_r: array of cint; (* PCM data for right channel *)
        const nsamples: cint; (* number of samples per channel *)
        mp3buf: pcuchar; (* pointer to encoded MP3 stream *)
        const mp3buf_size: cint (* number of valid octets in this stream *)
      ): cint; cdecl; external LIB_LAME;

(*
 * REQUIRED:
 * lame_encode_flush will flush the intenal PCM buffers, padding with
 * 0's to make sure the final frame is complete, and then flush
 * the internal MP3 buffers, and thus may return a
 * final few mp3 frames.  'mp3buf' should be at least 7200 bytes long
 * to hold all possible emitted data.
 *
 * will also write id3v1 tags (if any) into the bitstream
 *
 * return code = number of bytes output to mp3buf. Can be 0
 *)
function lame_encode_flush(
        gfp: Plame_global_flags; (* global context handle *)
        mp3buf: pcuchar; (* pointer to encoded MP3 stream *)
        size: cint): cint; cdecl; external LIB_LAME; (* number of valid octets in this stream *)

(*
 * OPTIONAL:
 * lame_encode_flush_nogap will flush the internal mp3 buffers and pad
 * the last frame with ancillary data so it is a complete mp3 frame.
 *
 * 'mp3buf' should be at least 7200 bytes long
 * to hold all possible emitted data.
 *
 * After a call to this routine, the outputed mp3 data is complete, but
 * you may continue to encode new PCM samples and write future mp3 data
 * to a different file.  The two mp3 files will play back with no gaps
 * if they are concatenated together.
 *
 * This routine will NOT write id3v1 tags into the bitstream.
 *
 * return code = number of bytes output to mp3buf. Can be 0
 *)
function lame_encode_flush_nogap(
        gfp: Plame_global_flags; (* global context handle *)
        mp3buf: pcuchar; (* pointer to encoded MP3 stream *)
        size: cint (* number of valid octets in this stream *)
      ): cint; cdecl; external LIB_LAME;

(*
 * OPTIONAL:
 * Normally, this is called by lame_init_params().  It writes id3v2 and
 * Xing headers into the front of the bitstream, and sets frame counters
 * and bitrate histogram data to 0.  You can also call this after
 * lame_encode_flush_nogap().
 *)
function lame_init_bitstream(
        gfp: Plame_global_flags (* global context handle *)
      ): cint; cdecl; external LIB_LAME;

(*
 * OPTIONAL:    some simple statistics
 * a bitrate histogram to visualize the distribution of used frame sizes
 * a stereo mode histogram to visualize the distribution of used stereo
 *   modes, useful in joint-stereo mode only
 *   0: LR    left-right encoded
 *   1: LR-I  left-right and intensity encoded (currently not supported)
 *   2: MS    mid-side encoded
 *   3: MS-I  mid-side and intensity encoded (currently not supported)
 *
 * attention: don't call them after lame_encode_finish
 * suggested: lame_encode_flush -> lame_*_hist -> lame_close
 *)

procedure lame_bitrate_hist(const gfp: Plame_global_flags; bitrate_count: pcint); cdecl; external LIB_LAME;
procedure lame_bitrate_kbps(const gfp: Plame_global_flags; bitrate_kbps: pcint); cdecl; external LIB_LAME;
procedure lame_stereo_mode_hist(const gfp: Plame_global_flags; stereo_mode_count: pcint); cdecl; external LIB_LAME;

procedure lame_bitrate_stereo_mode_hist(const gfp: Plame_global_flags; bitrate_stmode_count: pcint); cdecl; external LIB_LAME;

procedure lame_block_type_hist (const gfp: Plame_global_flags; btype_count: pcint); cdecl; external LIB_LAME;

procedure lame_bitrate_block_type_hist (const gfp: Plame_global_flags; bitrate_btype_count: pcint); cdecl; external LIB_LAME;

{$ifndef DEPRECATED_OR_OBSOLETE_CODE_REMOVED}
{$else}
(*
 * OPTIONAL:
 * lame_mp3_tags_fid will rewrite a Xing VBR tag to the mp3 file with file
 * pointer fid.  These calls perform forward and backwards seeks, so make
 * sure fid is a real file.  Make sure lame_encode_flush has been called,
 * and all mp3 data has been written to the file before calling this
 * function.
 * NOTE:
 * if VBR  tags are turned off by the user, or turned off by LAME because
 * the output is not a regular file, this call does nothing
 * NOTE:
 * LAME wants to read from the file to skip an optional ID3v2 tag, so
 * make sure you opened the file for writing and reading.
 * NOTE:
 * You can call lame_get_lametag_frame instead, if you want to insert
 * the lametag yourself.
*)
procedure lame_mp3_tags_fid(gfp: Plame_global_flags; fid: pointer); cdecl; external LIB_LAME;
{$endif}

(*
 * OPTIONAL:
 * lame_get_lametag_frame copies the final LAME-tag into 'buffer'.
 * The function returns the number of bytes copied into buffer, or
 * the required buffer size, if the provided buffer is too small.
 * Function failed, if the return value is larger than 'size'!
 * Make sure lame_encode flush has been called before calling this function.
 * NOTE:
 * if VBR  tags are turned off by the user, or turned off by LAME,
 * this call does nothing and returns 0.
 * NOTE:
 * LAME inserted an empty frame in the beginning of mp3 audio data,
 * which you have to replace by the final LAME-tag frame after encoding.
 * In case there is no ID3v2 tag, usually this frame will be the very first
 * data in your mp3 file. If you put some other leading data into your
 * file, you'll have to do some bookkeeping about where to write this buffer.
 *)
function lame_get_lametag_frame(const gfp: Plame_global_flags; buffer: pcuchar; size: csize_t): csize_t; cdecl; external LIB_LAME;

(*
 * REQUIRED:
 * final call to free all remaining buffers
 *)
function lame_close(gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

{$ifdef DEPRECATED_OR_OBSOLETE_CODE_REMOVED}
{$else}
(*
 * OBSOLETE:
 * lame_encode_finish combines lame_encode_flush() and lame_close() in
 * one call.  However, once this call is made, the statistics routines
 * will no longer work because the data will have been cleared, and
 * lame_mp3_tags_fid() cannot be called to add data to the VBR header
 *)
function lame_encode_finish(gfp: Plame_global_flags; mp3buf: pcuchar; size: cint): cint; cdecl; external LIB_LAME;
{$endif}

(*********************************************************************
 *
 * decoding
 *
 * a simple interface to mpglib, part of mpg123, is also included if
 * libmp3lame is compiled with HAVE_MPGLIB
 *
 *********************************************************************)

type
  hip_global_struct = record
  end;

  hip_global_flags = hip_global_struct;

  hip_t = pointer;
  Phip_global_flags = hip_t;

  Pmp3data_struct = ^mp3data_struct;
  mp3data_struct = record
    header_parsed: cint; (* 1 if header was parsed and following data was computed *)
    stereo: cint; (* number of channels *)
    samplerate: cint; (* sample rate *)
    bitrate: cint; (* bitrate *)
    mode: cint; (* mp3 frame type *)
    mode_ext: cint; (* mp3 frame type *)
    framesize: cint; (* number of samples per mp3 frame *)
  
    (* this data is only computed if mpglib detects a Xing VBR header *)
    nsamp: culong; (* number of samples in mp3 file. *)
    totalframes: cint; (* total number of frames in mp3 file *)
  
    (* this data is not currently computed by the mpglib routines *)
    framenum: cint; (* frames decoded counter *)
  end;

(* required call to initialize decoder *)
function hip_decode_init(): hip_t; cdecl; external LIB_LAME;

(* cleanup call to exit decoder *)
function hip_decode_exit(gfp: hip_t): cint; cdecl; external LIB_LAME;

(* HIP reporting functions *)
procedure hip_set_errorf(gfp: hip_t; f: lame_report_function); cdecl; external LIB_LAME;
procedure hip_set_debugf(gfp: hip_t; f: lame_report_function); cdecl; external LIB_LAME;
procedure hip_set_msgf  (gfp: hip_t; f: lame_report_function); cdecl; external LIB_LAME;

(*********************************************************************
 * input 1 mp3 frame, output (maybe) pcm data.
 *
 *  nout = hip_decode(hip, mp3buf,len,pcm_l,pcm_r);
 *
 * input:
 *    len          :  number of bytes of mp3 data in mp3buf
 *    mp3buf[len]  :  mp3 data to be decoded
 *
 * output:
 *    nout:  -1    : decoding error
 *            0    : need more data before we can complete the decode
 *           >0    : returned 'nout' samples worth of data in pcm_l,pcm_r
 *    pcm_l[nout]  : left channel data
 *    pcm_r[nout]  : right channel data
 *
 *********************************************************************)
function hip_decode(gfp: hip_t;
                    mp3buf: pcuchar;
                    len: csize_t;
                    pcm_l: array of cshort;
                    pcm_r: array of cshort
                   ): cint; cdecl; external LIB_LAME;

(* same as hip_decode, and also returns mp3 header data *)
function hip_decode_headers(gfp: hip_t;
                            mp3buf: pcuchar;
                            len: csize_t;
                            pcm_l: array of cshort;
                            pcm_r: array of cshort;
                            mp3data: Pmp3data_struct
                           ): cint; cdecl; external LIB_LAME;

(* same as hip_decode, but returns at most one frame *)
function hip_decode1(gfp: hip_t;
                     mp3buf: pcuchar;
                     len: csize_t;
                     pcm_l: array of cshort;
                     pcm_r: array of cshort
                    ): cint; cdecl; external LIB_LAME;

(* same as hip_decode1, but returns at most one frame and mp3 header data *)
function hip_decode1_headers(gfp: hip_t;
                             mp3buf: pcuchar;
                             len: csize_t;
                             pcm_l: array of cshort;
                             pcm_r: array of cshort;
                             mp3data: Pmp3data_struct
                            ): cint; cdecl; external LIB_LAME;

(* same as hip_decode1_headers, but also returns enc_delay and enc_padding
   from VBR Info tag, (-1 if no info tag was found) *)
function hip_decode1_headersB(gfp: hip_t;
                              mp3buf: pcuchar;
                              len: csize_t;
                              pcm_l: array of cshort;
                              pcm_r: array of cshort;
                              mp3data: Pmp3data_struct;
                              enc_delay: pcint;
                              enc_padding: pcint
                             ): cint; cdecl; external LIB_LAME;

(* OBSOLETE:
 * lame_decode... functions are there to keep old code working
 * but it is strongly recommended to replace calls by hip_decode...
 * function calls, see above.
 *)
{$ifdef DEPRECATED_OR_OBSOLETE_CODE_REMOVED}
{$else}
function lame_decode_init(): cint; cdecl; external LIB_LAME;
function lame_decode(
        mp3buf: pcuchar;
        len: cint;
        pcm_l: array of cshort;
        pcm_r: array of cshort): cint; cdecl; external LIB_LAME;
function lame_decode_headers(
        mp3buf: pcuchar;
        len: cint;
        pcm_l: array of cshort;
        pcm_r: array of cshort;
        mp3data: Pmp3data_struct): cint; cdecl; external LIB_LAME;
function lame_decode1(
        mp3buf: pcuchar;
        len: cint;
        pcm_l: array of cshort;
        pcm_r: array of cshort): cint; cdecl; external LIB_LAME;
function lame_decode1_headers(
        mp3buf: pcuchar;
        len: cint;
        pcm_l: array of cshort;
        pcm_r: array of cshort;
        mp3data: Pmp3data_struct): cint; cdecl; external LIB_LAME;
function lame_decode1_headersB(
        mp3buf: pcuchar;
        len: cint;
        pcm_l: array of cshort;
        pcm_r: array of cshort;
        mp3data: Pmp3data_struct;
        enc_delay: pcint;
        enc_padding: pcint): cint; cdecl; external LIB_LAME;
function lame_decode_exit(): cint; cdecl; external LIB_LAME;

{$endif} (* obsolete lame_decode API calls *)

(*********************************************************************
 *
 * id3tag stuff
 *
 *********************************************************************)

(*
 * id3tag.h -- Interface to write ID3 version 1 and 2 tags.
 *
 * Copyright (C) 2000 Don Melton.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307, USA.
 *)

type
  id3tag_genre_list_cbf = procedure (number: cint; genre: pcchar; data: pointer); cdecl;
 
(* utility to obtain alphabetically sorted list of genre names with numbers *)
procedure id3tag_genre_list(
        handler: id3tag_genre_list_cbf;
        cookie: pointer); cdecl; external LIB_LAME;

procedure id3tag_init(gfp: lame_t); cdecl; external LIB_LAME;

(* force addition of version 2 tag *)
procedure id3tag_add_v2(gfp: lame_t); cdecl; external LIB_LAME;

(* add only a version 1 tag *)
procedure id3tag_v1_only(gfp: lame_t); cdecl; external LIB_LAME;

(* add only a version 2 tag *)
procedure id3tag_v2_only(gfp: lame_t); cdecl; external LIB_LAME;

(* pad version 1 tag with spaces instead of nulls *)
procedure id3tag_space_v1(gfp: lame_t); cdecl; external LIB_LAME;

(* pad version 2 tag with extra 128 bytes *)
procedure id3tag_pad_v2(gfp: lame_t); cdecl; external LIB_LAME;

(* pad version 2 tag with extra n bytes *)
procedure id3tag_set_pad(gfp: lame_t; n: csize_t); cdecl; external LIB_LAME;

procedure id3tag_set_title(gfp: lame_t; const title: pcchar); cdecl; external LIB_LAME;
procedure id3tag_set_artist(gfp: lame_t; const artist: pcchar); cdecl; external LIB_LAME;
procedure id3tag_set_album(gfp: lame_t; const album: pcchar); cdecl; external LIB_LAME;
procedure id3tag_set_year(gfp: lame_t; const year: pcchar); cdecl; external LIB_LAME;
procedure id3tag_set_comment(gfp: lame_t; const comment: pcchar); cdecl; external LIB_LAME;
            
(* return -1 result if track number is out of ID3v1 range
                    and ignored for ID3v1 *)
function id3tag_set_track(gfp: lame_t; const track: pcchar): cint; cdecl; external LIB_LAME;

(* return non-zero result if genre name or number is invalid
  result 0: OK
  result -1: genre number out of range
  result -2: no valid ID3v1 genre name, mapped to ID3v1 'Other'
             but taken as-is for ID3v2 genre tag *)
function id3tag_set_genre(gfp: lame_t; const genre: pcchar): cint; cdecl; external LIB_LAME;

(* return non-zero result if field name is invalid *)
function id3tag_set_fieldvalue(gfp: lame_t; const fieldvalue: pcchar): cint; cdecl; external LIB_LAME;

(* return non-zero result if image type is invalid *)
function id3tag_set_albumart(gfp: lame_t; const image: pcchar; size: csize_t): cint; cdecl; external LIB_LAME;

(* lame_get_id3v1_tag copies ID3v1 tag into buffer.
 * Function returns number of bytes copied into buffer, or number
 * of bytes rquired if buffer 'size' is too small.
 * Function fails, if returned value is larger than 'size'.
 * NOTE:
 * This functions does nothing, if user/LAME disabled ID3v1 tag.
 *)
function lame_get_id3v1_tag(gfp: lame_t; buffer: pcuchar; size: csize_t): csize_t; cdecl; external LIB_LAME;

(* lame_get_id3v2_tag copies ID3v2 tag into buffer.
 * Function returns number of bytes copied into buffer, or number
 * of bytes rquired if buffer 'size' is too small.
 * Function fails, if returned value is larger than 'size'.
 * NOTE:
 * This functions does nothing, if user/LAME disabled ID3v2 tag.
 *)
function lame_get_id3v2_tag(gfp: lame_t; buffer: pcuchar; size: csize_t): csize_t; cdecl; external LIB_LAME;

(* normaly lame_init_param writes ID3v2 tags into the audio stream
 * Call lame_set_write_id3tag_automatic(gfp, 0) before lame_init_param
 * to turn off this behaviour and get ID3v2 tag with above function
 * write it yourself into your file.
 *)
procedure lame_set_write_id3tag_automatic(gfp: Plame_global_flags; write_id3tag_automatic: cint); cdecl; external LIB_LAME;
function lame_get_write_id3tag_automatic(const gfp: Plame_global_flags): cint; cdecl; external LIB_LAME;

(* experimental *)
function id3tag_set_textinfo_latin1(gfp: lame_t; const id: pcchar; const text: pcchar): cint; cdecl; external LIB_LAME;

(* experimental *)
function id3tag_set_comment_latin1(gfp: lame_t; const lang: pcchar; const desc: pcchar; const text: pcchar): cint; cdecl; external LIB_LAME;

{$ifdef DEPRECATED_OR_OBSOLETE_CODE_REMOVED}
{$else}
(* experimental *)
function id3tag_set_textinfo_ucs2(gfp: lame_t; id: pcchar; const text: pcushort): cint; cdecl; external LIB_LAME;

(* experimental *)
function id3tag_set_comment_ucs2(gfp: lame_t; lang: pcchar; const desc: pcushort; const text: pcushort): cint; cdecl; external LIB_LAME;

(* experimental *)
function id3tag_set_fieldvalue_ucs2(gfp: lame_t; const fieldvalue: pcushort): cint; cdecl; external LIB_LAME;
{$endif}

(* experimental *)
function id3tag_set_fieldvalue_utf16(gfp: lame_t; const fieldvalue: pcushort): cint; cdecl; external LIB_LAME;

(* experimental *)
function id3tag_set_textinfo_utf16(gfp: lame_t; id: pcchar; const text: pcushort): cint; cdecl; external LIB_LAME;

(* experimental *)
function id3tag_set_comment_utf16(gfp: lame_t; lang: pcchar; const desc: pcushort; const text: pcushort): cint; cdecl; external LIB_LAME;

(***********************************************************************
*
*  list of valid bitrates [kbps] & sample frequencies [Hz].
*  first index: 0: MPEG-2   values  (sample frequencies 16...24 kHz)
*               1: MPEG-1   values  (sample frequencies 32...48 kHz)
*               2: MPEG-2.5 values  (sample frequencies  8...12 kHz)
***********************************************************************)

var
  bitrate_table: array[0..2, 0..15] of cint; external LIB_LAME;
  samplerate_table: array[0..2, 0..3] of cint; external LIB_LAME;

(* access functions for use in DLL, global vars are not exported *)
function lame_get_bitrate(mpeg_version: cint; table_index: cint): cint; cdecl; external LIB_LAME;
function lame_get_samplerate(mpeg_version: cint; table_index: cint): cint; cdecl; external LIB_LAME;

const
(* maximum size of albumart image (128KB), which affects LAME_MAXMP3BUFFER
   as well since lame_encode_buffer() also returns ID3v2 tag data *)
  LAME_MAXALBUMART = (128 * 1024);

(* maximum size of mp3buffer needed if you encode at most 1152 samples for
   each call to lame_encode_buffer.  see lame_encode_buffer() below  
   (LAME_MAXMP3BUFFER is now obsolete) *)
  LAME_MAXMP3BUFFER = (16384 + LAME_MAXALBUMART);

type
  lame_errorcodes_t = (
    FRONTEND_FILETOOLARGE = -82,
    FRONTEND_WRITEERROR = -81,
    FRONTEND_READERROR = -80,

    LAME_INTERNALERROR = -13,
    LAME_BADSAMPFREQ = -12,
    LAME_BADBITRATE = -11,
    LAME_NOMEM = -10,
    LAME_GENERICERROR=  -1,
    LAME_NOERROR = 0
  );

const
  LAME_OKAY = 0;

  
implementation


end.

