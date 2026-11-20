// © 2026 NVIDIA Corporation

// Hardware video encode/decode command submission
// Video formats: https://learn.microsoft.com/en-us/windows/win32/medfound/recommended-8-bit-yuv-formats-for-video-rendering
package NRI

when ODIN_DEBUG {
	@(private = "file")
	lib_path :: "./Lib/Debug/"
} else {
	@(private = "file")
	lib_path :: "./Lib/Release/"
}

when ODIN_OS == .Windows {
	when ODIN_ARCH == .amd64 {
		foreign import lib {lib_path + "NRI.lib", "system:dxgi.lib", "system:dxguid.lib", "system:d3d12.lib", "system:d3d11.lib", "system:User32.lib"}
	// } else when ODIN_ARCH == .arm64 {
		// foreign import lib {lib_path + "aarch64-windows.lib"}
	} else do #panic("Unsupported architecture")
// } else when ODIN_OS == .Linux { // Todo: add linux binaries
	// when ODIN_ARCH == .amd64 {
	// 	foreign import lib {lib_path + "libx86_64-linux.a"}
	// } else when ODIN_ARCH == .arm64 {
	// 	foreign import lib {lib_path + "libaarch64-linux.a"}
	// } else do #panic("Unsupported architecture")
} else do #panic("Unsupported OS")

NRI_VIDEO_H :: 1

VideoSession           :: struct {}
VideoSessionParameters :: struct {}
VideoPicture           :: struct {}

VideoSessionType :: enum u8 {
	DECODE  = 0,
	ENCODE  = 1,
	MAX_NUM = 2,
}

VideoDecodeArgumentType :: enum u8 {
	PICTURE_PARAMETERS          = 0,
	INVERSE_QUANTIZATION_MATRIX = 1,
	SLICE_CONTROL               = 2,
	MAX_NUM                     = 3,
}

VideoFrameType :: enum u8 {
	IDR     = 0,
	I       = 1,
	P       = 2,
	B       = 3,
	MAX_NUM = 4,
}

VideoEncodeRateControlMode :: enum u8 {
	CQP     = 0,
	CBR     = 1,
	VBR     = 2,
	MAX_NUM = 3,
}

VideoAV1ReferenceName :: enum u8 {
	NONE    = 0,
	LAST    = 1,
	LAST2   = 2,
	LAST3   = 3,
	GOLDEN  = 4,
	BWDREF  = 5,
	ALTREF2 = 6,
	ALTREF  = 7,
	MAX_NUM = 8,
}

VideoPictureUsage :: enum u8 {
	DECODE_OUTPUT    = 0,
	DECODE_REFERENCE = 1,
	ENCODE_INPUT     = 2,
	ENCODE_REFERENCE = 3,
	MAX_NUM          = 4,
}

VideoPictureRole :: enum u8 {
	DECODE_OUTPUT           = 0,
	DECODE_REFERENCE        = 1,
	DECODE_SETUP            = 2,
	DECODE_OUTPUT_AND_SETUP = 3,
	ENCODE_INPUT            = 4,
	ENCODE_REFERENCE        = 5,
	ENCODE_RECONSTRUCTED    = 6,
	MAX_NUM                 = 7,
}

VideoDecodeBitstreamSourceBitsEnum :: enum u8 {
	BUFFER = 0,
	HOST   = 1,
}

VideoDecodeBitstreamSourceBits :: bit_set[VideoDecodeBitstreamSourceBitsEnum; u8]

VideoH264SequenceParameterSetBitsEnum :: enum u16 {
	CONSTRAINT_SET0                 = 0,
	CONSTRAINT_SET1                 = 1,
	CONSTRAINT_SET2                 = 2,
	CONSTRAINT_SET3                 = 3,
	CONSTRAINT_SET4                 = 4,
	CONSTRAINT_SET5                 = 5,
	DIRECT_8X8_INFERENCE            = 6,
	MB_ADAPTIVE_FRAME_FIELD         = 7,
	FRAME_MBS_ONLY                  = 8,
	DELTA_PIC_ORDER_ALWAYS_ZERO     = 9,
	SEPARATE_COLOUR_PLANE           = 10,
	GAPS_IN_FRAME_NUM_ALLOWED       = 11,
	QPPRIME_Y_ZERO_TRANSFORM_BYPASS = 12,
	FRAME_CROPPING                  = 13,
}

VideoH264SequenceParameterSetBits :: bit_set[VideoH264SequenceParameterSetBitsEnum; u16]

VideoH264PictureParameterSetBitsEnum :: enum u8 {
	TRANSFORM_8X8_MODE                = 0,
	REDUNDANT_PIC_CNT_PRESENT         = 1,
	CONSTRAINED_INTRA_PRED            = 2,
	DEBLOCKING_FILTER_CONTROL_PRESENT = 3,
	WEIGHTED_PRED                     = 4,
	BOTTOM_FIELD_PIC_ORDER_IN_FRAME   = 5,
	ENTROPY_CODING_MODE               = 6,
}

VideoH264PictureParameterSetBits :: bit_set[VideoH264PictureParameterSetBitsEnum; u8]

VideoH264DecodePictureBitsEnum :: enum u8 {
	FIELD_PICTURE            = 0,
	INTRA                    = 1,
	IDR                      = 2,
	BOTTOM_FIELD             = 3,
	REFERENCE                = 4,
	COMPLEMENTARY_FIELD_PAIR = 5,
}

VideoH264DecodePictureBits :: bit_set[VideoH264DecodePictureBitsEnum; u8]

VideoH264DecodeReferenceBitsEnum :: enum u8 {
	TOP_FIELD    = 0, // a frame reference sets neither or both of "TOP_FIELD" and "BOTTOM_FIELD"
	BOTTOM_FIELD = 1, // a frame reference sets neither or both of "TOP_FIELD" and "BOTTOM_FIELD"
	LONG_TERM    = 2, // a frame reference sets neither or both of "TOP_FIELD" and "BOTTOM_FIELD"
	NON_EXISTING = 3, // a frame reference sets neither or both of "TOP_FIELD" and "BOTTOM_FIELD"
}

VideoH264DecodeReferenceBits :: bit_set[VideoH264DecodeReferenceBitsEnum; u8]

VideoH265DecodePictureBitsEnum :: enum u8 {
	IRAP                       = 0,
	IDR                        = 1,
	REFERENCE                  = 2,
	SHORT_TERM_REF_PIC_SET_SPS = 3,
}

VideoH265DecodePictureBits :: bit_set[VideoH265DecodePictureBitsEnum; u8]

VideoH265ProfileTierLevelBitsEnum :: enum u8 {
	TIER                  = 0,
	PROGRESSIVE_SOURCE    = 1,
	INTERLACED_SOURCE     = 2,
	NON_PACKED_CONSTRAINT = 3,
	FRAME_ONLY_CONSTRAINT = 4,
}
VideoH265ProfileTierLevelBits :: bit_set[VideoH265ProfileTierLevelBitsEnum; u8]

VideoH265VideoParameterSetBitsEnum :: enum u8 {
	TEMPORAL_ID_NESTING             = 0,
	SUB_LAYER_ORDERING_INFO_PRESENT = 1,
	TIMING_INFO_PRESENT             = 2,
	POC_PROPORTIONAL_TO_TIMING      = 3,
}
VideoH265VideoParameterSetBits :: bit_set[VideoH265VideoParameterSetBitsEnum; u8]

VideoH265SequenceParameterSetBitsEnum :: enum u32 {
	TEMPORAL_ID_NESTING             = 0,
	SEPARATE_COLOUR_PLANE           = 1,
	CONFORMANCE_WINDOW              = 2,
	SUB_LAYER_ORDERING_INFO_PRESENT = 3,
	SCALING_LIST_ENABLED            = 4,
	SCALING_LIST_DATA_PRESENT       = 5,
	AMP_ENABLED                     = 6,
	SAMPLE_ADAPTIVE_OFFSET_ENABLED  = 7,
	PCM_ENABLED                     = 8,
	PCM_LOOP_FILTER_DISABLED        = 9,
	LONG_TERM_REF_PICS_PRESENT      = 10,
	TEMPORAL_MVP_ENABLED            = 11,
	STRONG_INTRA_SMOOTHING_ENABLED  = 12,
	VUI_PARAMETERS_PRESENT          = 13,
}

VideoH265SequenceParameterSetBits :: bit_set[VideoH265SequenceParameterSetBitsEnum; u32]

VideoH265PictureParameterSetBitsEnum :: enum u32 {
	DEPENDENT_SLICE_SEGMENTS_ENABLED       = 0,
	OUTPUT_FLAG_PRESENT                    = 1,
	SIGN_DATA_HIDING_ENABLED               = 2,
	CABAC_INIT_PRESENT                     = 3,
	CONSTRAINED_INTRA_PRED                 = 4,
	TRANSFORM_SKIP_ENABLED                 = 5,
	CU_QP_DELTA_ENABLED                    = 6,
	SLICE_CHROMA_QP_OFFSETS_PRESENT        = 7,
	WEIGHTED_PRED                          = 8,
	WEIGHTED_BIPRED                        = 9,
	TRANSQUANT_BYPASS_ENABLED              = 10,
	TILES_ENABLED                          = 11,
	ENTROPY_CODING_SYNC_ENABLED            = 12,
	UNIFORM_SPACING                        = 13,
	LOOP_FILTER_ACROSS_TILES_ENABLED       = 14,
	LOOP_FILTER_ACROSS_SLICES_ENABLED      = 15,
	DEBLOCKING_FILTER_CONTROL_PRESENT      = 16,
	DEBLOCKING_FILTER_OVERRIDE_ENABLED     = 17,
	DEBLOCKING_FILTER_DISABLED             = 18,
	SCALING_LIST_DATA_PRESENT              = 19,
	LISTS_MODIFICATION_PRESENT             = 20,
	SLICE_SEGMENT_HEADER_EXTENSION_PRESENT = 21,
}
VideoH265PictureParameterSetBits :: bit_set[VideoH265PictureParameterSetBitsEnum; u32]

VideoH265ShortTermRefPicSetBitsEnum :: enum u8 {
	INTER_REF_PIC_SET_PREDICTION = 0,
	DELTA_RPS_SIGN               = 1,
}

VideoH265ShortTermRefPicSetBits :: bit_set[VideoH265ShortTermRefPicSetBitsEnum; u8]

VideoEncodeBitsEnum :: enum u8 {
	FORCE_KEY_FRAME = 0,
}

VideoEncodeBits :: bit_set[VideoEncodeBitsEnum; u8]

VideoAV1EncodeFeatureBitsEnum :: enum u32 {
	ORDER_HINT_TOOLS              = 0,
	LOOP_RESTORATION_FILTER       = 1,
	FORCED_INTEGER_MOTION_VECTORS = 2,
	AUTO_SEGMENTATION             = 3,
	CDEF_FILTERING                = 4,
	QUANTIZATION_DELTAS           = 5,
	LOOP_FILTER_DELTAS            = 6,
}

VideoAV1EncodeFeatureBits :: bit_set[VideoAV1EncodeFeatureBitsEnum; u32]

VideoAV1SequenceBitsEnum :: enum u32 {
	STILL_PICTURE                 = 0,
	REDUCED_STILL_PICTURE_HEADER  = 1,
	USE_128X128_SUPERBLOCK        = 2,
	ENABLE_FILTER_INTRA           = 3,
	ENABLE_INTRA_EDGE_FILTER      = 4,
	ENABLE_INTERINTRA_COMPOUND    = 5,
	ENABLE_MASKED_COMPOUND        = 6,
	ENABLE_WARPED_MOTION          = 7,
	ENABLE_DUAL_FILTER            = 8,
	ENABLE_ORDER_HINT             = 9,
	ENABLE_JNT_COMP               = 10,
	ENABLE_REF_FRAME_MVS          = 11,
	FRAME_ID_NUMBERS_PRESENT      = 12,
	ENABLE_SUPERRES               = 13,
	ENABLE_CDEF                   = 14,
	ENABLE_RESTORATION            = 15,
	FILM_GRAIN_PARAMS_PRESENT     = 16,
	TIMING_INFO_PRESENT           = 17,
	INITIAL_DISPLAY_DELAY_PRESENT = 18,
	MONO_CHROME                   = 19,
	COLOR_RANGE                   = 20,
	SEPARATE_UV_DELTA_Q           = 21,
	COLOR_DESCRIPTION_PRESENT     = 22,
}
VideoAV1SequenceBits :: bit_set[VideoAV1SequenceBitsEnum; u32]

VideoAV1PictureBitsEnum :: enum u32 {
	ERROR_RESILIENT_MODE            = 0,
	DISABLE_CDF_UPDATE              = 1,
	USE_SUPERRES                    = 2,
	RENDER_AND_FRAME_SIZE_DIFFERENT = 3,
	ALLOW_SCREEN_CONTENT_TOOLS      = 4,
	IS_FILTER_SWITCHABLE            = 5,
	FORCE_INTEGER_MV                = 6,
	FRAME_SIZE_OVERRIDE             = 7,
	BUFFER_REMOVAL_TIME_PRESENT     = 8,
	ALLOW_INTRABC                   = 9,
	FRAME_REFS_SHORT_SIGNALING      = 10,
	ALLOW_HIGH_PRECISION_MV         = 11,
	IS_MOTION_MODE_SWITCHABLE       = 12,
	USE_REF_FRAME_MVS               = 13,
	DISABLE_FRAME_END_UPDATE_CDF    = 14,
	ALLOW_WARPED_MOTION             = 15,
	REDUCED_TX_SET                  = 16,
	REFERENCE_SELECT                = 17,
	SKIP_MODE_PRESENT               = 18,
	DELTA_Q_PRESENT                 = 19,
	DELTA_LF_PRESENT                = 20,
	DELTA_LF_MULTI                  = 21,
	SEGMENTATION_ENABLED            = 22,
	SEGMENTATION_UPDATE_MAP         = 23,
	SEGMENTATION_TEMPORAL_UPDATE    = 24,
	SEGMENTATION_UPDATE_DATA        = 25,
	USES_LR                         = 26,
	USES_CHROMA_LR                  = 27,
	SHOW_FRAME                      = 28,
	SHOWABLE_FRAME                  = 29,
	APPLY_GRAIN                     = 30,
}

VideoAV1PictureBits :: bit_set[VideoAV1PictureBitsEnum; u32]

VideoSessionDesc :: struct {
	type:            VideoSessionType,
	codec:           VideoCodec, // fixed profiles: H.264 High, H.265 Main/Main10 (by format), AV1 Main; H.264 sessions are progressive-only
	format:          Format,
	width:           u32,
	height:          u32,
	maxReferenceNum: u32,
	av1FilmGrain:    bool,       // AV1 decode: permits "APPLY_GRAIN"; textures require "TextureDesc::videoAV1FilmGrain"; UNSUPPORTED if unavailable
}

VideoCapabilities :: struct {
	widthMin:                              u32,
	heightMin:                             u32,
	widthMax:                              u32,
	heightMax:                             u32,
	pictureAccessGranularityWidth:         u32,
	pictureAccessGranularityHeight:        u32,
	maxReferenceNum:                       u32,
	bitstreamOffsetAlignment:              u32,
	bitstreamSizeAlignment:                u32,
	bitstreamSizeMax:                      u64,         // maximum "bitstream.size" for decode and "dstBitstream.size" for encode
	metadataOffsetAlignment:               u32,
	resolvedMetadataOffsetAlignment:       u32,
	encodeFeedbackMaxPendingNum:           u32,         // maximum per-session feedback ranges not yet consumed by "GetVideoEncodeFeedback"; reset by "ResetVideoSession"
	metadataSize:                          u64,         // minimum "VideoEncodeDesc::metadata" range size in bytes
	resolvedMetadataSize:                  u64,         // minimum "VideoEncodeDesc::resolvedMetadata" range size in bytes
	decodeBitstreamSourceMask:             VideoDecodeBitstreamSourceBits,
	resolvedMetadataState:                 AccessStage, // required state while the resolved metadata is written
	resolvedMetadataQueueType:             QueueType,   // queue used by the operation that writes resolved metadata
	dpbTextureArrayMinLayerNum:            u32,         // minimum layer count when "dpbTextureArrayRequired" is true
	decodeDpbAndOutputCoincide:            bool,        // decode output and reconstructed/DPB setup may use the same texture subresource
	decodeDpbAndOutputDistinct:            bool,        // decode output and reconstructed/DPB setup may use different texture subresources (textures with the session extent)
	decodeReferenceOnlyRequired:           bool,        // decode DPB pictures (setup and references) must use "VIDEO_REFERENCE_ONLY" textures, which only video decode can access
	dpbTextureArrayRequired:               bool,        // all decode or encode DPB pictures must use layers of one texture
	decodeNativeArgumentsSupported:        bool,
	encodeBitstreamRangeSizeSupported:     bool,        // if false, encode output ranges must extend to the end of the buffer
	encodeFeedbackSupported:               bool,
	encodeFeedbackResolveRequired:         bool,        // if true, call "CmdResolveVideoEncodeFeedback" after the encode
	encodeReferenceCountOverrideSupported: bool,        // H.264/H.265: if false, active L0 (P/B) and L1 (B) counts must match PPS defaults (1 per list for default H.265 parameters)
}

VideoAV1Capabilities :: struct {
	av1MaxLevel:                                u32,
	av1MaxTileColumnNum:                        u32,
	av1MaxTileRowNum:                           u32,
	av1MinTileWidth:                            u32,
	av1MinTileHeight:                           u32,
	av1MaxTileWidth:                            u32,
	av1MaxTileHeight:                           u32,
	av1SuperblockSizeMask:                      u32,
	av1MaxSingleReferenceNum:                   u32,
	av1SingleReferenceNameMask:                 u32,
	av1MaxUnidirectionalCompoundReferenceNum:   u32,
	av1UnidirectionalCompoundReferenceNameMask: u32,
	av1MaxBidirectionalCompoundReferenceNum:    u32,
	av1BidirectionalCompoundReferenceNameMask:  u32,
	av1MaxTemporalLayerNum:                     u32,
	av1MaxSpatialLayerNum:                      u32,
	av1MaxOperatingPointNum:                    u32,
	av1MinQIndex:                               u32,
	av1MaxQIndex:                               u32,
	av1EncodeRequiredFeatureFlags:              VideoAV1EncodeFeatureBits,
	av1EncodeSupportedFeatureFlags:             VideoAV1EncodeFeatureBits,
}

VideoReference :: struct {
	picture: ^VideoPicture,
	slot:    u32,
}

VideoBitstreamRange :: struct {
	buffer: ^Buffer,
	offset: u64, // decode slice/tile offsets are relative to this offset
	size:   u64, // decode bitstream byte range; H.264/H.265 neutral decode expects Annex-B byte stream data
}

VideoDecodeBitstreamRange :: struct {
	buffer: ^Buffer,
	data:   rawptr, // host range starts at this address; "offset" applies only to "buffer"
	offset: u64,
	size:   u64,    // H.264/H.265 neutral decode expects Annex-B byte stream data
}

VideoPictureDesc :: struct {
	texture: ^Texture,
	usage:   VideoPictureUsage,
	width:   Dim_t, // defaults to the texture width
	height:  Dim_t, // defaults to the texture height
	layer:   Dim_t,
}

VideoPictureState :: struct {
	required:               AccessLayoutStage, // state required while the picture participates in CmdDecodeVideo or CmdEncodeVideo
	videoQueueAfter:        AccessLayoutStage, // destination state of the optional post-video transition
	consumerQueueBefore:    AccessLayoutStage, // source state for the consumer queue transition
	transitionOnVideoQueue: bool,              // transition "required" -> "videoQueueAfter" before cross-queue consumption
}

VideoH264SequenceParameterSetDesc :: struct {
	flags:                             VideoH264SequenceParameterSetBits,
	profileIdc:                        u8,
	levelIdc:                          u8,  // "level_idc" as coded in the bitstream: 10 times the level number (e.g. 41 = level 4.1), level 1b is not supported
	chromaFormatIdc:                   u8,
	sequenceParameterSetId:            u8,
	bitDepthLumaMinus8:                u8,
	bitDepthChromaMinus8:              u8,
	log2MaxFrameNumMinus4:             u8,
	pictureOrderCountType:             u8,
	offsetForNonReferencePicture:      i32,
	offsetForTopToBottomField:         i32,
	log2MaxPictureOrderCountLsbMinus4: u8,
	referenceFrameNum:                 u8,
	pictureWidthInMbsMinus1:           u16,
	pictureHeightInMapUnitsMinus1:     u16,
	frameCropLeftOffset:               u16, // used with "FRAME_CROPPING", in "CropUnitX" units (2 luma samples for 4:2:0)
	frameCropRightOffset:              u16,
	frameCropTopOffset:                u16, // used with "FRAME_CROPPING", in "CropUnitY" units (2 luma samples for 4:2:0 progressive)
	frameCropBottomOffset:             u16,
}

VideoH264PictureParameterSetDesc :: struct {
	flags:                         VideoH264PictureParameterSetBits,
	sequenceParameterSetId:        u8,
	pictureParameterSetId:         u8,
	refIndexL0DefaultActiveMinus1: u8,
	refIndexL1DefaultActiveMinus1: u8,
	weightedBipredIdc:             u8,
	pictureInitQpMinus26:          i8,
	pictureInitQsMinus26:          i8,
	chromaQpIndexOffset:           i8,
	secondChromaQpIndexOffset:     i8,
}

VideoH264SessionParametersDesc :: struct {
	sequenceParameterSets:      ^VideoH264SequenceParameterSetDesc,
	sequenceParameterSetNum:    u32,
	pictureParameterSets:       ^VideoH264PictureParameterSetDesc,
	pictureParameterSetNum:     u32,
	maxSequenceParameterSetNum: u32, // defaults to "sequenceParameterSetNum"
	maxPictureParameterSetNum:  u32, // defaults to "pictureParameterSetNum"
}

VideoH265ProfileTierLevelDesc :: struct {
	flags:             VideoH265ProfileTierLevelBits,
	generalProfileIdc: u8,
	generalLevelIdc:   u8, // "general_level_idc" as coded in the bitstream: 30 times the level number (e.g. 120 = level 4)
}

VideoH265DecPicBufMgrDesc :: struct {
	maxDecPicBufferingMinus1: [8]u8,
	maxNumReorderPics:        [8]u8,
	maxLatencyIncreasePlus1:  [8]u32,
}

VideoH265ScalingListsDesc :: struct {
	scalingList4x4:         [6][16]u8,
	scalingList8x8:         [6][64]u8,
	scalingList16x16:       [6][64]u8,
	scalingList32x32:       [2][64]u8,
	scalingListDCCoef16x16: [6]u8,
	scalingListDCCoef32x32: [2]u8,
}

VideoH265ShortTermRefPicSetDesc :: struct {
	flags:               VideoH265ShortTermRefPicSetBits,
	numNegativePics:     u8,
	numPositivePics:     u8,
	deltaIdxMinus1:      u32,
	useDeltaFlag:        u16,
	absDeltaRpsMinus1:   u16,
	usedByCurrPicFlag:   u16,
	usedByCurrPicS0Flag: u16,
	usedByCurrPicS1Flag: u16,
	deltaPocS0Minus1:    [16]u16,
	deltaPocS1Minus1:    [16]u16,
}

VideoH265LongTermRefPicsSpsDesc :: struct {
	usedByCurrPicLtSpsFlag: u32,
	ltRefPicPocLsbSps:      [32]u32,
}

VideoH265VideoParameterSetDesc :: struct {
	flags:                    VideoH265VideoParameterSetBits,
	videoParameterSetId:      u8,
	maxSubLayersMinus1:       u8,
	numUnitsInTick:           u32,
	timeScale:                u32,
	numTicksPocDiffOneMinus1: u32,
	profileTierLevel:         VideoH265ProfileTierLevelDesc,
	decPicBufMgr:             VideoH265DecPicBufMgrDesc,
}

VideoH265SequenceParameterSetDesc :: struct {
	flags:                                VideoH265SequenceParameterSetBits,
	videoParameterSetId:                  u8,
	maxSubLayersMinus1:                   u8,
	sequenceParameterSetId:               u8,
	chromaFormatIdc:                      u8,
	pictureWidthInLumaSamples:            u32,
	pictureHeightInLumaSamples:           u32,
	bitDepthLumaMinus8:                   u8,
	bitDepthChromaMinus8:                 u8,
	log2MaxPictureOrderCountLsbMinus4:    u8,
	log2MinLumaCodingBlockSizeMinus3:     u8,
	log2DiffMaxMinLumaCodingBlockSize:    u8,
	log2MinLumaTransformBlockSizeMinus2:  u8,
	log2DiffMaxMinLumaTransformBlockSize: u8,
	maxTransformHierarchyDepthInter:      u8,
	maxTransformHierarchyDepthIntra:      u8,
	pcmSampleBitDepthLumaMinus1:          u8,
	pcmSampleBitDepthChromaMinus1:        u8,
	log2MinPcmLumaCodingBlockSizeMinus3:  u8,
	log2DiffMaxMinPcmLumaCodingBlockSize: u8,
	confWinLeftOffset:                    u32,
	confWinRightOffset:                   u32,
	confWinTopOffset:                     u32,
	confWinBottomOffset:                  u32,
	shortTermRefPicSets:                  ^VideoH265ShortTermRefPicSetDesc,
	numShortTermRefPicSets:               u8,
	numLongTermRefPicsSps:                u8,
	profileTierLevel:                     VideoH265ProfileTierLevelDesc,
	decPicBufMgr:                         VideoH265DecPicBufMgrDesc,
	scalingLists:                         ^VideoH265ScalingListsDesc,
	longTermRefPicsSps:                   ^VideoH265LongTermRefPicsSpsDesc,
}

VideoH265PictureParameterSetDesc :: struct {
	flags:                         VideoH265PictureParameterSetBits,
	pictureParameterSetId:         u8,
	sequenceParameterSetId:        u8,
	videoParameterSetId:           u8,
	numExtraSliceHeaderBits:       u8,
	refIndexL0DefaultActiveMinus1: u8,
	refIndexL1DefaultActiveMinus1: u8,
	initQpMinus26:                 i8,
	diffCuQpDeltaDepth:            u8,
	cbQpOffset:                    i8,
	crQpOffset:                    i8,
	betaOffsetDiv2:                i8,
	tcOffsetDiv2:                  i8,
	log2ParallelMergeLevelMinus2:  u8,
	tileColumnNumMinus1:           u8,
	tileRowNumMinus1:              u8,
	columnWidthMinus1:             [19]u16,
	rowHeightMinus1:               [21]u16,
	scalingLists:                  ^VideoH265ScalingListsDesc,
}

VideoH265SessionParametersDesc :: struct {
	videoParameterSets:         ^VideoH265VideoParameterSetDesc,
	videoParameterSetNum:       u32,
	sequenceParameterSets:      ^VideoH265SequenceParameterSetDesc,
	sequenceParameterSetNum:    u32,
	pictureParameterSets:       ^VideoH265PictureParameterSetDesc,
	pictureParameterSetNum:     u32,
	maxVideoParameterSetNum:    u32, // defaults to "videoParameterSetNum"
	maxSequenceParameterSetNum: u32, // defaults to "sequenceParameterSetNum"
	maxPictureParameterSetNum:  u32, // defaults to "pictureParameterSetNum"
}

VideoAnnexBParameterSetsDesc :: struct {
	codec:       VideoCodec,
	h264Sps:     ^VideoH264SequenceParameterSetDesc,
	h264Pps:     ^VideoH264PictureParameterSetDesc,
	h265Vps:     ^VideoH265VideoParameterSetDesc,
	h265Sps:     ^VideoH265SequenceParameterSetDesc,
	h265Pps:     ^VideoH265PictureParameterSetDesc,
	dst:         ^u8, // if null, only "writtenSize" is returned
	dstSize:     u64,
	writtenSize: u64,
}

VideoAnnexBEndOfStreamDesc :: struct {
	codec:       VideoCodec,
	dst:         ^u8, // if null, only "writtenSize" is returned
	dstSize:     u64,
	writtenSize: u64,
}

VideoAV1SequenceDesc :: struct {
	flags:                         VideoAV1SequenceBits,
	seqProfile:                    u8,
	bitDepth:                      u8,
	subsamplingX:                  u8,
	subsamplingY:                  u8,
	maxFrameWidthMinus1:           u16,
	maxFrameHeightMinus1:          u16,
	frameWidthBitsMinus1:          u8,
	frameHeightBitsMinus1:         u8,
	deltaFrameIdLengthMinus2:      u8,
	additionalFrameIdLengthMinus1: u8,
	orderHintBitsMinus1:           u8,
	seqForceIntegerMv:             u8,
	seqForceScreenContentTools:    u8,
	level:                         u8,
	colorPrimaries:                u8,
	transferCharacteristics:       u8,
	matrixCoefficients:            u8,
	chromaSamplePosition:          u8,
	numUnitsInDisplayTick:         u32,
	timeScale:                     u32,
	numTicksPerPictureMinus1:      u32,
}

VideoAV1ObuHeadersDesc :: struct {
	sequence:    VideoAV1SequenceDesc,
	dst:         ^u8, // if null, only "writtenSize" is returned
	dstSize:     u64,
	writtenSize: u64,
}

VideoAV1SessionParametersDesc :: struct {
	sequence: VideoAV1SequenceDesc,
}

VideoSessionParametersDesc :: struct {
	session:        ^VideoSession,
	h264Parameters: ^VideoH264SessionParametersDesc, // required for H.264 except decode using native arguments on a supporting backend
	h265Parameters: ^VideoH265SessionParametersDesc, // required for neutral H.265 decode; optional for native decode arguments and encode
	av1Parameters:  ^VideoAV1SessionParametersDesc,
}

VideoDecodeArgument :: struct {
	type: VideoDecodeArgumentType,
	size: u32,
	data: rawptr,
}

VideoH264EncodeReferenceDesc :: struct {
	frameType:            VideoFrameType,
	temporalLayer:        u8,
	listIndex:            u8,
	longTermReference:    u8,
	frameNum:             u32,
	pictureOrderCount:    i32,
	slot:                 u32,
	longTermPictureIndex: u16,
	longTermFrameIndex:   u16,
}

VideoH264DecodeReferenceDesc :: struct {
	flags:                 VideoH264DecodeReferenceBits,
	frameNum:              u16,
	slot:                  u32,
	topFieldOrderCount:    i32,
	bottomFieldOrderCount: i32,
}

VideoH264DecodePictureDesc :: struct {
	flags:                  VideoH264DecodePictureBits,
	sequenceParameterSetId: u8,
	pictureParameterSetId:  u8,
	frameNum:               u16,
	idrPictureId:           u16,
	topFieldOrderCount:     i32,
	bottomFieldOrderCount:  i32,
	sliceOffsets:           ^u32, // offsets to 4-byte Annex-B start codes, relative to the selected bitstream range start
	sliceOffsetNum:         u32,
	hasReferenceSlot:       bool, // if false, VideoDecodeDesc::dstSlot is used
	referenceSlot:          u32,
	references:             ^VideoH264DecodeReferenceDesc,
	referenceNum:           u32,
}

VideoH265ReferenceDesc :: struct {
	slot:              u32,
	pictureOrderCount: i32,
	temporalLayer:     u8,
	frameType:         VideoFrameType,
	longTerm:          u8, // decode only, encode supports short-term references only
	listIndex:         u8,
}

VideoH265DecodePictureDesc :: struct {
	flags:                               VideoH265DecodePictureBits,
	videoParameterSetId:                 u8,
	sequenceParameterSetId:              u8,
	pictureParameterSetId:               u8,
	pictureOrderCount:                   i32,
	numDeltaPocsOfRefRpsIdx:             u8,
	numBitsForShortTermRefPicSetInSlice: u16,
	sliceSegmentOffsets:                 ^u32, // offsets to 4-byte Annex-B start codes, relative to the selected bitstream range start
	sliceSegmentOffsetNum:               u32,
	references:                          ^VideoH265ReferenceDesc,
	referenceNum:                        u32,
}

VideoEncodeRateControlDesc :: struct {
	mode:                       VideoEncodeRateControlMode,
	qpI:                        u8,
	qpP:                        u8,
	qpB:                        u8,
	qpMin:                      u8,  // CBR/VBR QP range (AV1: Q index); omitted bounds use the supported codec limits
	qpMax:                      u8,
	frameRateNumerator:         u32,
	frameRateDenominator:       u32,
	targetBitrate:              u64, // CBR target bitrate, or VBR average bitrate
	maxBitrate:                 u64, // VBR peak bitrate; defaults to "targetBitrate"
	maxFrameBitSize:            u64,
	virtualBufferSizeMs:        u32,
	initialVirtualBufferSizeMs: u32,
}

VideoEncodePictureDesc :: struct {
	frameType:         VideoFrameType,
	temporalLayer:     u8,
	idrPictureId:      u16,
	frameIndex:        u32,
	pictureOrderCount: i32,
}

VideoH264EncodePictureDesc :: struct {
	sequenceParameterSetId: u8,
	pictureParameterSetId:  u8,
	references:             ^VideoH264EncodeReferenceDesc,
	referenceNum:           u32,
}

VideoH265EncodePictureDesc :: struct {
	videoParameterSetId:    u8,
	sequenceParameterSetId: u8,
	pictureParameterSetId:  u8,
}

VideoAV1ReferenceDesc :: struct {
	name:            VideoAV1ReferenceName, // NONE: a valid reference frame map entry ("ref_frame_idx") not used by the current frame; decode requires the complete map
	refFrameIndex:   u8,
	frameType:       VideoFrameType,
	orderHint:       u8,
	frameId:         u32,
	slot:            u32,
	savedOrderHints: ^u8,                   // if provided, must include 8 entries
}

VideoAV1TileLayoutDesc :: struct {
	columnNum:                 u8,
	rowNum:                    u8,
	tileSizeBytesMinus1:       u8,
	uniformSpacing:            u8,   // if set, omitted arrays are derived from the frame size
	contextUpdateTileId:       u16,
	miColumnStarts:            ^u16, // if provided, must include "columnNum + 1" entries
	miRowStarts:               ^u16, // if provided, must include "rowNum + 1" entries
	widthInSuperblocksMinus1:  ^u16, // if provided, must include "columnNum" entries
	heightInSuperblocksMinus1: ^u16, // if provided, must include "rowNum" entries
}

VideoAV1QuantizationDesc :: struct {
	deltaQYDc:    i8,
	deltaQUDc:    i8,
	deltaQUAc:    i8,
	deltaQVDc:    i8,
	deltaQVAc:    i8,
	qmY:          u8,
	qmU:          u8,
	qmV:          u8,
	usingQmatrix: u8,
	diffUvDelta:  u8,
}

VideoAV1LoopFilterDesc :: struct {
	level:           [4]u8,
	sharpness:       u8,
	deltaEnabled:    u8,
	deltaUpdate:     u8,
	updateModeDelta: u8,
	refDeltas:       [8]i8,
	modeDeltas:      [2]i8,
}

VideoAV1CdefDesc :: struct {
	yPrimaryStrength:    [8]u8, // 0..15
	ySecondaryStrength:  [8]u8, // 0..3 as coded in "cdef_y_sec_strength" (3 represents strength 4)
	uvPrimaryStrength:   [8]u8, // 0..15
	uvSecondaryStrength: [8]u8, // 0..3 as coded in "cdef_uv_sec_strength"
}

VideoAV1SegmentationDesc :: struct {
	featureEnabled: [8]u8,
	featureData:    [8][8]i16,
}

VideoAV1LoopRestorationDesc :: struct {
	frameRestorationType: [3]u8,
	lrUnitShift:          u8,
	lrUvShift:            u8,
}

VideoAV1GlobalMotionDesc :: struct {
	type:    [8]u8,
	invalid: [8]u8,
	params:  [8][6]i32,
}

VideoAV1FilmGrainDesc :: struct {
	chromaScalingFromLuma: u8,
	overlapFlag:           u8,
	clipToRestrictedRange: u8,
	updateGrain:           u8,
	matrixCoeffIsIdentity: u8,
	grainScalingMinus8:    u8,
	arCoeffLag:            u8,
	arCoeffShiftMinus6:    u8,
	grainScaleShift:       u8,
	filmGrainParamsRefIdx: u8,
	grainSeed:             u16,
	numYPoints:            u8,
	pointYValue:           [14]u8,
	pointYScaling:         [14]u8,
	numCbPoints:           u8,
	pointCbValue:          [10]u8,
	pointCbScaling:        [10]u8,
	numCrPoints:           u8,
	pointCrValue:          [10]u8,
	pointCrScaling:        [10]u8,
	arCoeffsYPlus128:      [24]u8,
	arCoeffsCbPlus128:     [25]u8,
	arCoeffsCrPlus128:     [25]u8,
	cbMult:                u8,
	cbLumaMult:            u8,
	cbOffset:              i16,
	crMult:                u8,
	crLumaMult:            u8,
	crOffset:              i16,
}

// State of a reference frame that later frame headers can depend on ("RefUpscaledWidth", "load_previous", "load_grain_params")
VideoAV1SavedFrameState :: struct {
	loopFilter:          VideoAV1LoopFilterDesc,   // "refDeltas" and "modeDeltas"
	segmentation:        VideoAV1SegmentationDesc, // "FeatureEnabled" and "FeatureData"
	globalMotion:        VideoAV1GlobalMotionDesc, // "gm_params"
	filmGrain:           VideoAV1FilmGrainDesc,    // all zero if no grain is applied
	upscaledWidthMinus1: u16,
	frameHeightMinus1:   u16,
	renderWidthMinus1:   u16,
	renderHeightMinus1:  u16,
	orderHint:           u8,
	applyGrain:          u8,                       // "apply_grain" ("load_grain_params" restores it)
	valid:               u8,                       // 0 if the frame inherited state that was not provided
}

VideoAV1EncodePictureDesc :: struct {
	currentFrameId:       u32,
	orderHint:            u8,
	refreshFrameFlags:    u8,
	primaryReferenceName: VideoAV1ReferenceName,
	flags:                VideoAV1PictureBits,
	renderWidthMinus1:    u16,
	renderHeightMinus1:   u16,
	codedDenom:           u8,
	interpolationFilter:  u8,  // AV1 "interpolation_filter": 0..4 (4 = SWITCHABLE)
	txMode:               u8,  // 0 selects the default, else AV1 "TxMode" 1..2 (LARGEST, SELECT); ONLY_4X4 is implied for lossless frames
	baseQIndex:           u8,
	cdefDampingMinus3:    u8,
	cdefBits:             u8,
	deltaQRes:            u8,
	deltaLfRes:           u8,
	tileLayout:           ^VideoAV1TileLayoutDesc,
	quantization:         ^VideoAV1QuantizationDesc,
	loopFilter:           ^VideoAV1LoopFilterDesc,
	cdef:                 ^VideoAV1CdefDesc,
	segmentation:         ^VideoAV1SegmentationDesc,
	loopRestoration:      ^VideoAV1LoopRestorationDesc,
	globalMotion:         ^VideoAV1GlobalMotionDesc,
	orderHints:           ^u8, // if provided, must include 8 entries
	references:           ^VideoAV1ReferenceDesc,
	referenceNum:         u32,
}

VideoAV1DecodeTileDesc :: struct {
	offset:      u32,
	size:        u32,
	row:         u16,
	column:      u16,
	anchorFrame: u8,
}

VideoAV1DecodePictureDesc :: struct {
	frameType:            VideoFrameType,
	orderHint:            u8,
	refreshFrameFlags:    u8,
	primaryReferenceName: VideoAV1ReferenceName,
	currentFrameId:       u32,
	frameHeaderOffset:    u32,
	flags:                VideoAV1PictureBits,
	renderWidthMinus1:    u16,
	renderHeightMinus1:   u16,
	baseQIndex:           u8,
	superresDenom:        u8,
	codedDenom:           u8,
	interpolationFilter:  u8,                       // AV1 "interpolation_filter": 0..4 (4 = SWITCHABLE)
	txMode:               u8,                       // AV1 "TxMode": 0..2 (ONLY_4X4, LARGEST, SELECT)
	cdefDampingMinus3:    u8,
	cdefBits:             u8,
	deltaQRes:            u8,
	deltaLfRes:           u8,
	tileLayout:           ^VideoAV1TileLayoutDesc,
	quantization:         ^VideoAV1QuantizationDesc,
	loopFilter:           ^VideoAV1LoopFilterDesc,
	cdef:                 ^VideoAV1CdefDesc,
	segmentation:         ^VideoAV1SegmentationDesc,
	loopRestoration:      ^VideoAV1LoopRestorationDesc,
	globalMotion:         ^VideoAV1GlobalMotionDesc,
	filmGrain:            ^VideoAV1FilmGrainDesc,   // used with "APPLY_GRAIN": resolved parameters ("load_grain_params" applied, e.g. "VideoAV1EncodeDecodeInfo::filmGrain")
	orderHints:           ^u8,                      // 8 entries indexed like AV1 "OrderHints[]" by reference frame name: 0 = INTRA_FRAME, 1..7 = LAST..ALTREF; named reference entries are overridden by "references[].orderHint"
	skipModeFrames:       [2]VideoAV1ReferenceName, // "SkipModeFrame[0..1]" used with "SKIP_MODE_PRESENT"
	tiles:                ^VideoAV1DecodeTileDesc,
	tileNum:              u32,
	references:           ^VideoAV1ReferenceDesc,
	referenceNum:         u32,
}

VideoDecodeDesc :: struct {
	session:      ^VideoSession,
	parameters:   ^VideoSessionParameters,
	bitstream:    VideoDecodeBitstreamRange, // provide at least one source supported by "VideoCapabilities::decodeBitstreamSourceMask"
	dstPicture:   ^VideoPicture,
	setupPicture: ^VideoPicture,             // reconstructed/DPB setup picture; required for distinct mode, may alias "dstPicture" in coincide mode. "APPLY_GRAIN" requires a distinct setup picture in sessions with DPB slots
	references:   ^VideoReference,
	referenceNum: u32,
	dstSlot:      u32,                       // default setup slot, always written; neutral H.264 may override it with "referenceSlot"; native DXVA "CurrPic" must use "dstSlot" and reference "PicEntry" indices must match "VideoReference::slot"

	// for non-reference pictures, use a slot whose picture is no longer needed, never one referenced by this or a later decode
	arguments:       ^VideoDecodeArgument,        // native DXVA frame arguments; if omitted, the neutral codec picture description is used
	argumentNum:     u32,
	h264PictureDesc: ^VideoH264DecodePictureDesc, // neutral H.264 picture description; required if "argumentNum" is 0
	h265PictureDesc: ^VideoH265DecodePictureDesc, // neutral H.265 picture description; required if "argumentNum" is 0
	av1PictureDesc:  ^VideoAV1DecodePictureDesc,  // neutral AV1 picture description; required if "argumentNum" is 0
}

VideoEncodeFeedback :: struct {
	errorFlags:                   u64,
	averageQp:                    u64,
	intraCodingUnitNum:           u64,
	interCodingUnitNum:           u64,
	skipCodingUnitNum:            u64,
	averageMotionEstimationX:     u64,
	averageMotionEstimationY:     u64,
	encodedBitstreamWrittenBytes: u64,
	writtenSubregionNum:          u64,
	encodedBitstreamOffset:       u64, // offset of valid encoded data relative to VideoEncodeDesc::dstBitstream.offset
}

VideoAV1EncodeDecodeInfoDesc :: struct {
	feedback:                 ^VideoEncodeFeedback,
	sequence:                 ^VideoAV1SequenceDesc,
	encodedPayloadHeader:     ^u8,                        // encoded payload prefix sufficient to parse the frame header and locate every tile; may be the complete payload. Payload-header input may be unsupported; returned bitstream ranges are bounded by "feedback"
	encodedPayloadHeaderSize: u64,
	references:               ^VideoAV1ReferenceDesc,     // previous AV1 DPB snapshot; required for inter frames, without it the frame is a key frame (as encoded with "FORCE_KEY_FRAME")
	referenceNum:             u32,
	pictureDesc:              ^VideoEncodePictureDesc,    // submitted picture description; required if "encodedPayloadHeader" is not provided
	av1PictureDesc:           ^VideoAV1EncodePictureDesc, // submitted AV1 picture description; required if "encodedPayloadHeader" is not provided
	savedFrameStates:         ^VideoAV1SavedFrameState,   // 8 entries indexed by "refFrameIndex": the "savedFrameState" of the frame that last refreshed each slot; required for headers that inherit state
}

VideoAV1EncodeDecodeInfo :: struct {
	bitstreamOffset:           u64,                       // offset relative to VideoEncodeFeedback::encodedBitstreamOffset
	bitstreamSize:             u64,
	sequence:                  VideoAV1SequenceDesc,
	picture:                   VideoAV1DecodePictureDesc,
	tiles:                     [64]VideoAV1DecodeTileDesc,
	tileLayout:                VideoAV1TileLayoutDesc,
	miColumnStarts:            [65]u16,
	miRowStarts:               [65]u16,
	widthInSuperblocksMinus1:  [64]u16,
	heightInSuperblocksMinus1: [64]u16,
	references:                [15]VideoAV1ReferenceDesc, // 7 named entries, then a NONE entry for every other valid reference frame map entry
	quantization:              VideoAV1QuantizationDesc,
	loopFilter:                VideoAV1LoopFilterDesc,
	cdef:                      VideoAV1CdefDesc,
	segmentation:              VideoAV1SegmentationDesc,
	loopRestoration:           VideoAV1LoopRestorationDesc,
	globalMotion:              VideoAV1GlobalMotionDesc,
	filmGrain:                 VideoAV1FilmGrainDesc,     // resolved parameters ("load_grain_params" applied)
	savedFrameState:           VideoAV1SavedFrameState,   // store into "savedFrameStates[i]" for every slot "i" in "picture.refreshFrameFlags"
}

VideoEncodeDesc :: struct {
	session:                ^VideoSession,
	parameters:             ^VideoSessionParameters,
	srcPicture:             ^VideoPicture,
	dstBitstream:           VideoBitstreamRange,
	bitstreamMetadataSize:  u64,                         // bytes of codec metadata already written before the current frame payload
	pictureDesc:            ^VideoEncodePictureDesc,
	rateControlDesc:        ^VideoEncodeRateControlDesc,
	flags:                  VideoEncodeBits,
	reconstructedPicture:   ^VideoPicture,               // reconstructed/DPB setup picture; required for sessions with DPB slots, also for non-reference pictures (B frames, AV1 "refreshFrameFlags = 0"): the slot is written, but not referenced afterwards
	metadata:               ^Buffer,                     // opaque encode metadata; required if "VideoCapabilities::metadataSize" is non-zero
	metadataOffset:         u64,
	resolvedMetadata:       ^Buffer,                     // opaque feedback metadata consumed by "GetVideoEncodeFeedback" after the required resolve operation; a pending range must not be reused
	resolvedMetadataOffset: u64,
	references:             ^VideoReference,
	referenceNum:           u32,
	reconstructedSlot:      u32,
	h264PictureDesc:        ^VideoH264EncodePictureDesc,
	h265PictureDesc:        ^VideoH265EncodePictureDesc, // parameter set selection; all ids default to 0
	av1PictureDesc:         ^VideoAV1EncodePictureDesc,
	h265ReferenceDescs:     ^VideoH265ReferenceDesc,
}

// When discarding recorded video commands, reset affected command buffers and call "ResetVideoSession" before recording further commands for the session
// Threadsafe: no
VideoInterface :: struct {
	// Session
	// {
	GetVideoCapabilities:          proc "c" (device: ^Device, videoSessionDesc: ^VideoSessionDesc, videoCapabilities: ^VideoCapabilities) -> Result,
	GetVideoAV1Capabilities:       proc "c" (device: ^Device, videoSessionDesc: ^VideoSessionDesc, videoAV1Capabilities: ^VideoAV1Capabilities) -> Result,
	CreateVideoSession:            proc "c" (device: ^Device, videoSessionDesc: ^VideoSessionDesc, videoSession: ^^VideoSession) -> Result,
	CreateVideoSessionParameters:  proc "c" (device: ^Device, videoSessionParametersDesc: ^VideoSessionParametersDesc, videoSessionParameters: ^^VideoSessionParameters) -> Result,
	CreateVideoPicture:            proc "c" (device: ^Device, videoPictureDesc: ^VideoPictureDesc, videoPicture: ^^VideoPicture) -> Result,
	DestroyVideoSession:           proc "c" (videoSession: ^VideoSession),
	ResetVideoSession:             proc "c" (videoSession: ^VideoSession),
	DestroyVideoSessionParameters: proc "c" (videoSessionParameters: ^VideoSessionParameters),
	DestroyVideoPicture:           proc "c" (videoPicture: ^VideoPicture),

	// Returns the states required for caller-recorded decode/encode picture barriers
	GetVideoPictureState: proc "c" (videoPicture: ^VideoPicture, role: VideoPictureRole, state: ^VideoPictureState) -> Result,

	// Serializes H.264 SPS/PPS or H.265 VPS/SPS/PPS parameter sets to Annex-B bytes. Pass "dst = nullptr" to query the required byte size in "writtenSize"
	WriteVideoAnnexBParameterSets: proc "c" (annexBParameterSetsDesc: ^VideoAnnexBParameterSetsDesc) -> Result,

	// Serializes H.264 end-of-sequence/end-of-stream or H.265 EOS/EOB Annex-B NAL units. Pass "dst = nullptr" to query the required byte size in "writtenSize"
	WriteVideoAnnexBEndOfStream: proc "c" (annexBEndOfStreamDesc: ^VideoAnnexBEndOfStreamDesc) -> Result,

	// Serializes AV1 temporal delimiter and sequence header OBUs. Pass "dst = nullptr" to query the required byte size in "writtenSize"
	WriteVideoAV1ObuHeaders: proc "c" (av1ObuHeadersDesc: ^VideoAV1ObuHeadersDesc) -> Result,

	// }
	
	// Command buffer
	// {
	// Video decode/encode command buffers must be created from "QueueType::VIDEO_DECODE" or "QueueType::VIDEO_ENCODE" queues.
	// Commands for the same video session must be recorded in submission order
	CmdDecodeVideo: proc "c" (commandBuffer: ^CommandBuffer, videoDecodeDesc: ^VideoDecodeDesc),
	CmdEncodeVideo: proc "c" (commandBuffer: ^CommandBuffer, videoEncodeDesc: ^VideoEncodeDesc),

	// Required only if "VideoCapabilities::encodeFeedbackResolveRequired" is true. Uses the advertised queue and buffer state
	CmdResolveVideoEncodeFeedback: proc "c" (commandBuffer: ^CommandBuffer, videoSession: ^VideoSession, resolvedMetadata: ^Buffer, resolvedMetadataOffset: u64),
	GetVideoEncodeFeedback:        proc "c" (videoSession: ^VideoSession, resolvedMetadataReadback: ^Buffer, resolvedMetadataOffset: u64, feedback: ^VideoEncodeFeedback) -> Result,
	GetVideoAV1EncodeDecodeInfo:   proc "c" (videoSession: ^VideoSession, resolvedMetadataReadback: ^Buffer, resolvedMetadataOffset: u64, desc: ^VideoAV1EncodeDecodeInfoDesc, info: ^VideoAV1EncodeDecodeInfo) -> Result,
}

