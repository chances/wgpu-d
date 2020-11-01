module wgpu.bindings;
// AUTOMATICALLY GENERATED: DO NOT EDIT


        import core.stdc.config;
        import core.stdc.stdarg: va_list;
        static import core.simd;
        static import std.conv;

        struct Int128 { long lower; long upper; }
        struct UInt128 { ulong lower; ulong upper; }

        struct __locale_data { int dummy; }



alias _Bool = bool;
struct dpp {
    static struct Opaque(int N) {
        void[N] bytes;
    }

    static bool isEmpty(T)() {
        return T.tupleof.length == 0;
    }
    static struct Move(T) {
        T* ptr;
    }


    static auto move(T)(ref T value) {
        return Move!T(&value);
    }
    mixin template EnumD(string name, T, string prefix) if(is(T == enum)) {
        private static string _memberMixinStr(string member) {
            import std.conv: text;
            import std.array: replace;
            return text(` `, member.replace(prefix, ""), ` = `, T.stringof, `.`, member, `,`);
        }
        private static string _enumMixinStr() {
            import std.array: join;
            string[] ret;
            ret ~= "enum " ~ name ~ "{";
            static foreach(member; __traits(allMembers, T)) {
                ret ~= _memberMixinStr(member);
            }
            ret ~= "}";
            return ret.join("\n");
        }
        mixin(_enumMixinStr());
    }
}

extern(C)
{
    alias fsfilcnt_t = c_ulong;
    alias fsblkcnt_t = c_ulong;
    alias blkcnt_t = c_long;
    alias blksize_t = c_long;
    alias register_t = c_long;
    alias u_int64_t = c_ulong;
    alias u_int32_t = uint;
    alias u_int16_t = ushort;
    alias u_int8_t = ubyte;
    alias key_t = int;
    alias caddr_t = char*;
    alias daddr_t = int;
    alias ssize_t = c_long;
    alias id_t = uint;
    alias pid_t = int;
    alias off_t = c_long;
    alias uid_t = uint;
    alias nlink_t = c_ulong;
    alias mode_t = uint;
    alias gid_t = uint;
    alias dev_t = c_ulong;
    alias ino_t = c_ulong;
    alias loff_t = c_long;
    alias fsid_t = __fsid_t;
    alias u_quad_t = c_ulong;
    alias quad_t = c_long;
    alias u_long = c_ulong;
    alias u_int = uint;
    alias u_short = ushort;
    alias u_char = ubyte;
    c_ulong gnu_dev_makedev(uint, uint) @nogc nothrow;
    uint gnu_dev_minor(c_ulong) @nogc nothrow;
    uint gnu_dev_major(c_ulong) @nogc nothrow;
    int pselect(int, fd_set*, fd_set*, fd_set*, const(timespec)*, const(__sigset_t)*) @nogc nothrow;
    int select(int, fd_set*, fd_set*, fd_set*, timeval*) @nogc nothrow;
    alias fd_mask = c_long;
    struct fd_set
    {
        c_long[16] __fds_bits;
    }
    alias __fd_mask = c_long;
    alias suseconds_t = c_long;
    enum _Anonymous_0
    {
        P_ALL = 0,
        P_PID = 1,
        P_PGID = 2,
    }
    enum P_ALL = _Anonymous_0.P_ALL;
    enum P_PID = _Anonymous_0.P_PID;
    enum P_PGID = _Anonymous_0.P_PGID;
    alias idtype_t = _Anonymous_0;
    static c_ulong __uint64_identity(c_ulong) @nogc nothrow;
    static uint __uint32_identity(uint) @nogc nothrow;
    static ushort __uint16_identity(ushort) @nogc nothrow;
    alias timer_t = void*;
    alias time_t = c_long;
    struct timeval
    {
        c_long tv_sec;
        c_long tv_usec;
    }
    struct timespec
    {
        c_long tv_sec;
        c_long tv_nsec;
    }
    alias sigset_t = __sigset_t;
    alias clockid_t = int;
    alias clock_t = c_long;
    struct __sigset_t
    {
        c_ulong[16] __val;
    }
    alias __sig_atomic_t = int;
    alias __socklen_t = uint;
    alias __intptr_t = c_long;
    alias __caddr_t = char*;
    alias __loff_t = c_long;
    alias __syscall_ulong_t = c_ulong;
    alias __syscall_slong_t = c_long;
    alias __ssize_t = c_long;
    alias __fsword_t = c_long;
    alias __fsfilcnt64_t = c_ulong;
    alias __fsfilcnt_t = c_ulong;
    alias __fsblkcnt64_t = c_ulong;
    alias __fsblkcnt_t = c_ulong;
    alias __blkcnt64_t = c_long;
    alias __blkcnt_t = c_long;
    alias __blksize_t = c_long;
    alias __timer_t = void*;
    alias __clockid_t = int;
    alias __key_t = int;
    alias __daddr_t = int;
    alias __suseconds_t = c_long;
    alias __useconds_t = uint;
    alias __time_t = c_long;
    alias __id_t = uint;
    alias __rlim64_t = c_ulong;
    alias __rlim_t = c_ulong;
    alias __clock_t = c_long;
    struct __fsid_t
    {
        int[2] __val;
    }
    alias __pid_t = int;
    alias __off64_t = c_long;
    alias __off_t = c_long;
    alias __nlink_t = c_ulong;
    alias __mode_t = uint;
    alias __ino64_t = c_ulong;
    alias __ino_t = c_ulong;
    alias __gid_t = uint;
    alias __uid_t = uint;
    alias __dev_t = c_ulong;
    alias __uintmax_t = c_ulong;
    alias __intmax_t = c_long;
    alias __u_quad_t = c_ulong;
    alias __quad_t = c_long;
    alias __uint64_t = c_ulong;
    alias __int64_t = c_long;
    alias __uint32_t = uint;
    alias __int32_t = int;
    alias __uint16_t = ushort;
    alias __int16_t = short;
    alias __uint8_t = ubyte;
    alias __int8_t = byte;
    alias __u_long = c_ulong;
    alias __u_int = uint;
    alias __u_short = ushort;
    alias __u_char = ubyte;
    struct __pthread_cond_s
    {
        static union _Anonymous_1
        {
            ulong __wseq;
            static struct _Anonymous_2
            {
                uint __low;
                uint __high;
            }
            _Anonymous_2 __wseq32;
        }
        _Anonymous_1 _anonymous_3;
        auto __wseq() @property @nogc pure nothrow { return _anonymous_3.__wseq; }
        void __wseq(_T_)(auto ref _T_ val) @property @nogc pure nothrow { _anonymous_3.__wseq = val; }
        auto __wseq32() @property @nogc pure nothrow { return _anonymous_3.__wseq32; }
        void __wseq32(_T_)(auto ref _T_ val) @property @nogc pure nothrow { _anonymous_3.__wseq32 = val; }
        static union _Anonymous_4
        {
            ulong __g1_start;
            static struct _Anonymous_5
            {
                uint __low;
                uint __high;
            }
            _Anonymous_5 __g1_start32;
        }
        _Anonymous_4 _anonymous_6;
        auto __g1_start() @property @nogc pure nothrow { return _anonymous_6.__g1_start; }
        void __g1_start(_T_)(auto ref _T_ val) @property @nogc pure nothrow { _anonymous_6.__g1_start = val; }
        auto __g1_start32() @property @nogc pure nothrow { return _anonymous_6.__g1_start32; }
        void __g1_start32(_T_)(auto ref _T_ val) @property @nogc pure nothrow { _anonymous_6.__g1_start32 = val; }
        uint[2] __g_refs;
        uint[2] __g_size;
        uint __g1_orig_size;
        uint __wrefs;
        uint[2] __g_signals;
    }
    alias WGPUNonZeroU64 = ulong;
    alias WGPUOption_NonZeroU32 = c_ulong;
    alias WGPUOption_NonZeroU64 = c_ulong;
    alias WGPUOption_AdapterId = ulong;
    alias WGPUOption_BufferId = ulong;
    alias WGPUOption_SamplerId = ulong;
    alias WGPUOption_SurfaceId = ulong;
    alias WGPUOption_TextureViewId = ulong;
    struct WGPUChainedStruct
    {
        const(WGPUChainedStruct)* next;
        uint s_type;
    }
    struct __pthread_mutex_s
    {
        int __lock;
        uint __count;
        int __owner;
        uint __nusers;
        int __kind;
        short __spins;
        short __elision;
        __pthread_internal_list __list;
    }
    struct __pthread_internal_list
    {
        __pthread_internal_list* __prev;
        __pthread_internal_list* __next;
    }
    alias __pthread_list_t = __pthread_internal_list;
    enum WGPUAddressMode
    {
        WGPUAddressMode_ClampToEdge = 0,
        WGPUAddressMode_Repeat = 1,
        WGPUAddressMode_MirrorRepeat = 2,
    }
    enum WGPUAddressMode_ClampToEdge = WGPUAddressMode.WGPUAddressMode_ClampToEdge;
    enum WGPUAddressMode_Repeat = WGPUAddressMode.WGPUAddressMode_Repeat;
    enum WGPUAddressMode_MirrorRepeat = WGPUAddressMode.WGPUAddressMode_MirrorRepeat;
    enum WGPUBackend
    {
        WGPUBackend_Empty = 0,
        WGPUBackend_Vulkan = 1,
        WGPUBackend_Metal = 2,
        WGPUBackend_Dx12 = 3,
        WGPUBackend_Dx11 = 4,
        WGPUBackend_Gl = 5,
        WGPUBackend_BrowserWebGpu = 6,
    }
    enum WGPUBackend_Empty = WGPUBackend.WGPUBackend_Empty;
    enum WGPUBackend_Vulkan = WGPUBackend.WGPUBackend_Vulkan;
    enum WGPUBackend_Metal = WGPUBackend.WGPUBackend_Metal;
    enum WGPUBackend_Dx12 = WGPUBackend.WGPUBackend_Dx12;
    enum WGPUBackend_Dx11 = WGPUBackend.WGPUBackend_Dx11;
    enum WGPUBackend_Gl = WGPUBackend.WGPUBackend_Gl;
    enum WGPUBackend_BrowserWebGpu = WGPUBackend.WGPUBackend_BrowserWebGpu;
    alias WGPUBackend_ = ubyte;
    enum WGPUBindingType
    {
        WGPUBindingType_UniformBuffer = 0,
        WGPUBindingType_StorageBuffer = 1,
        WGPUBindingType_ReadonlyStorageBuffer = 2,
        WGPUBindingType_Sampler = 3,
        WGPUBindingType_ComparisonSampler = 4,
        WGPUBindingType_SampledTexture = 5,
        WGPUBindingType_ReadonlyStorageTexture = 6,
        WGPUBindingType_WriteonlyStorageTexture = 7,
    }
    enum WGPUBindingType_UniformBuffer = WGPUBindingType.WGPUBindingType_UniformBuffer;
    enum WGPUBindingType_StorageBuffer = WGPUBindingType.WGPUBindingType_StorageBuffer;
    enum WGPUBindingType_ReadonlyStorageBuffer = WGPUBindingType.WGPUBindingType_ReadonlyStorageBuffer;
    enum WGPUBindingType_Sampler = WGPUBindingType.WGPUBindingType_Sampler;
    enum WGPUBindingType_ComparisonSampler = WGPUBindingType.WGPUBindingType_ComparisonSampler;
    enum WGPUBindingType_SampledTexture = WGPUBindingType.WGPUBindingType_SampledTexture;
    enum WGPUBindingType_ReadonlyStorageTexture = WGPUBindingType.WGPUBindingType_ReadonlyStorageTexture;
    enum WGPUBindingType_WriteonlyStorageTexture = WGPUBindingType.WGPUBindingType_WriteonlyStorageTexture;
    alias WGPUBindingType_ = uint;
    enum WGPUBlendFactor
    {
        WGPUBlendFactor_Zero = 0,
        WGPUBlendFactor_One = 1,
        WGPUBlendFactor_SrcColor = 2,
        WGPUBlendFactor_OneMinusSrcColor = 3,
        WGPUBlendFactor_SrcAlpha = 4,
        WGPUBlendFactor_OneMinusSrcAlpha = 5,
        WGPUBlendFactor_DstColor = 6,
        WGPUBlendFactor_OneMinusDstColor = 7,
        WGPUBlendFactor_DstAlpha = 8,
        WGPUBlendFactor_OneMinusDstAlpha = 9,
        WGPUBlendFactor_SrcAlphaSaturated = 10,
        WGPUBlendFactor_BlendColor = 11,
        WGPUBlendFactor_OneMinusBlendColor = 12,
    }
    enum WGPUBlendFactor_Zero = WGPUBlendFactor.WGPUBlendFactor_Zero;
    enum WGPUBlendFactor_One = WGPUBlendFactor.WGPUBlendFactor_One;
    enum WGPUBlendFactor_SrcColor = WGPUBlendFactor.WGPUBlendFactor_SrcColor;
    enum WGPUBlendFactor_OneMinusSrcColor = WGPUBlendFactor.WGPUBlendFactor_OneMinusSrcColor;
    enum WGPUBlendFactor_SrcAlpha = WGPUBlendFactor.WGPUBlendFactor_SrcAlpha;
    enum WGPUBlendFactor_OneMinusSrcAlpha = WGPUBlendFactor.WGPUBlendFactor_OneMinusSrcAlpha;
    enum WGPUBlendFactor_DstColor = WGPUBlendFactor.WGPUBlendFactor_DstColor;
    enum WGPUBlendFactor_OneMinusDstColor = WGPUBlendFactor.WGPUBlendFactor_OneMinusDstColor;
    enum WGPUBlendFactor_DstAlpha = WGPUBlendFactor.WGPUBlendFactor_DstAlpha;
    enum WGPUBlendFactor_OneMinusDstAlpha = WGPUBlendFactor.WGPUBlendFactor_OneMinusDstAlpha;
    enum WGPUBlendFactor_SrcAlphaSaturated = WGPUBlendFactor.WGPUBlendFactor_SrcAlphaSaturated;
    enum WGPUBlendFactor_BlendColor = WGPUBlendFactor.WGPUBlendFactor_BlendColor;
    enum WGPUBlendFactor_OneMinusBlendColor = WGPUBlendFactor.WGPUBlendFactor_OneMinusBlendColor;
    enum WGPUBlendOperation
    {
        WGPUBlendOperation_Add = 0,
        WGPUBlendOperation_Subtract = 1,
        WGPUBlendOperation_ReverseSubtract = 2,
        WGPUBlendOperation_Min = 3,
        WGPUBlendOperation_Max = 4,
    }
    enum WGPUBlendOperation_Add = WGPUBlendOperation.WGPUBlendOperation_Add;
    enum WGPUBlendOperation_Subtract = WGPUBlendOperation.WGPUBlendOperation_Subtract;
    enum WGPUBlendOperation_ReverseSubtract = WGPUBlendOperation.WGPUBlendOperation_ReverseSubtract;
    enum WGPUBlendOperation_Min = WGPUBlendOperation.WGPUBlendOperation_Min;
    enum WGPUBlendOperation_Max = WGPUBlendOperation.WGPUBlendOperation_Max;
    enum WGPUBufferMapAsyncStatus
    {
        WGPUBufferMapAsyncStatus_Success = 0,
        WGPUBufferMapAsyncStatus_Error = 1,
        WGPUBufferMapAsyncStatus_Unknown = 2,
        WGPUBufferMapAsyncStatus_ContextLost = 3,
    }
    enum WGPUBufferMapAsyncStatus_Success = WGPUBufferMapAsyncStatus.WGPUBufferMapAsyncStatus_Success;
    enum WGPUBufferMapAsyncStatus_Error = WGPUBufferMapAsyncStatus.WGPUBufferMapAsyncStatus_Error;
    enum WGPUBufferMapAsyncStatus_Unknown = WGPUBufferMapAsyncStatus.WGPUBufferMapAsyncStatus_Unknown;
    enum WGPUBufferMapAsyncStatus_ContextLost = WGPUBufferMapAsyncStatus.WGPUBufferMapAsyncStatus_ContextLost;
    enum WGPUCDeviceType
    {
        WGPUCDeviceType_Other = 0,
        WGPUCDeviceType_IntegratedGpu = 1,
        WGPUCDeviceType_DiscreteGpu = 2,
        WGPUCDeviceType_VirtualGpu = 3,
        WGPUCDeviceType_Cpu = 4,
    }
    enum WGPUCDeviceType_Other = WGPUCDeviceType.WGPUCDeviceType_Other;
    enum WGPUCDeviceType_IntegratedGpu = WGPUCDeviceType.WGPUCDeviceType_IntegratedGpu;
    enum WGPUCDeviceType_DiscreteGpu = WGPUCDeviceType.WGPUCDeviceType_DiscreteGpu;
    enum WGPUCDeviceType_VirtualGpu = WGPUCDeviceType.WGPUCDeviceType_VirtualGpu;
    enum WGPUCDeviceType_Cpu = WGPUCDeviceType.WGPUCDeviceType_Cpu;
    alias WGPUCDeviceType_ = ubyte;
    enum WGPUCompareFunction
    {
        WGPUCompareFunction_Undefined = 0,
        WGPUCompareFunction_Never = 1,
        WGPUCompareFunction_Less = 2,
        WGPUCompareFunction_Equal = 3,
        WGPUCompareFunction_LessEqual = 4,
        WGPUCompareFunction_Greater = 5,
        WGPUCompareFunction_NotEqual = 6,
        WGPUCompareFunction_GreaterEqual = 7,
        WGPUCompareFunction_Always = 8,
    }
    enum WGPUCompareFunction_Undefined = WGPUCompareFunction.WGPUCompareFunction_Undefined;
    enum WGPUCompareFunction_Never = WGPUCompareFunction.WGPUCompareFunction_Never;
    enum WGPUCompareFunction_Less = WGPUCompareFunction.WGPUCompareFunction_Less;
    enum WGPUCompareFunction_Equal = WGPUCompareFunction.WGPUCompareFunction_Equal;
    enum WGPUCompareFunction_LessEqual = WGPUCompareFunction.WGPUCompareFunction_LessEqual;
    enum WGPUCompareFunction_Greater = WGPUCompareFunction.WGPUCompareFunction_Greater;
    enum WGPUCompareFunction_NotEqual = WGPUCompareFunction.WGPUCompareFunction_NotEqual;
    enum WGPUCompareFunction_GreaterEqual = WGPUCompareFunction.WGPUCompareFunction_GreaterEqual;
    enum WGPUCompareFunction_Always = WGPUCompareFunction.WGPUCompareFunction_Always;
    enum WGPUCullMode
    {
        WGPUCullMode_None = 0,
        WGPUCullMode_Front = 1,
        WGPUCullMode_Back = 2,
    }
    enum WGPUCullMode_None = WGPUCullMode.WGPUCullMode_None;
    enum WGPUCullMode_Front = WGPUCullMode.WGPUCullMode_Front;
    enum WGPUCullMode_Back = WGPUCullMode.WGPUCullMode_Back;
    enum WGPUFilterMode
    {
        WGPUFilterMode_Nearest = 0,
        WGPUFilterMode_Linear = 1,
    }
    enum WGPUFilterMode_Nearest = WGPUFilterMode.WGPUFilterMode_Nearest;
    enum WGPUFilterMode_Linear = WGPUFilterMode.WGPUFilterMode_Linear;
    enum WGPUFrontFace
    {
        WGPUFrontFace_Ccw = 0,
        WGPUFrontFace_Cw = 1,
    }
    enum WGPUFrontFace_Ccw = WGPUFrontFace.WGPUFrontFace_Ccw;
    enum WGPUFrontFace_Cw = WGPUFrontFace.WGPUFrontFace_Cw;
    enum WGPUIndexFormat
    {
        WGPUIndexFormat_Uint16 = 0,
        WGPUIndexFormat_Uint32 = 1,
    }
    enum WGPUIndexFormat_Uint16 = WGPUIndexFormat.WGPUIndexFormat_Uint16;
    enum WGPUIndexFormat_Uint32 = WGPUIndexFormat.WGPUIndexFormat_Uint32;
    enum WGPUInputStepMode
    {
        WGPUInputStepMode_Vertex = 0,
        WGPUInputStepMode_Instance = 1,
    }
    enum WGPUInputStepMode_Vertex = WGPUInputStepMode.WGPUInputStepMode_Vertex;
    enum WGPUInputStepMode_Instance = WGPUInputStepMode.WGPUInputStepMode_Instance;
    enum WGPULoadOp
    {
        WGPULoadOp_Clear = 0,
        WGPULoadOp_Load = 1,
    }
    enum WGPULoadOp_Clear = WGPULoadOp.WGPULoadOp_Clear;
    enum WGPULoadOp_Load = WGPULoadOp.WGPULoadOp_Load;
    enum WGPULogLevel
    {
        WGPULogLevel_Off = 0,
        WGPULogLevel_Error = 1,
        WGPULogLevel_Warn = 2,
        WGPULogLevel_Info = 3,
        WGPULogLevel_Debug = 4,
        WGPULogLevel_Trace = 5,
    }
    enum WGPULogLevel_Off = WGPULogLevel.WGPULogLevel_Off;
    enum WGPULogLevel_Error = WGPULogLevel.WGPULogLevel_Error;
    enum WGPULogLevel_Warn = WGPULogLevel.WGPULogLevel_Warn;
    enum WGPULogLevel_Info = WGPULogLevel.WGPULogLevel_Info;
    enum WGPULogLevel_Debug = WGPULogLevel.WGPULogLevel_Debug;
    enum WGPULogLevel_Trace = WGPULogLevel.WGPULogLevel_Trace;
    enum WGPUPowerPreference
    {
        WGPUPowerPreference_Default = 0,
        WGPUPowerPreference_LowPower = 1,
        WGPUPowerPreference_HighPerformance = 2,
    }
    enum WGPUPowerPreference_Default = WGPUPowerPreference.WGPUPowerPreference_Default;
    enum WGPUPowerPreference_LowPower = WGPUPowerPreference.WGPUPowerPreference_LowPower;
    enum WGPUPowerPreference_HighPerformance = WGPUPowerPreference.WGPUPowerPreference_HighPerformance;
    enum WGPUPresentMode
    {
        WGPUPresentMode_Immediate = 0,
        WGPUPresentMode_Mailbox = 1,
        WGPUPresentMode_Fifo = 2,
    }
    enum WGPUPresentMode_Immediate = WGPUPresentMode.WGPUPresentMode_Immediate;
    enum WGPUPresentMode_Mailbox = WGPUPresentMode.WGPUPresentMode_Mailbox;
    enum WGPUPresentMode_Fifo = WGPUPresentMode.WGPUPresentMode_Fifo;
    enum WGPUPrimitiveTopology
    {
        WGPUPrimitiveTopology_PointList = 0,
        WGPUPrimitiveTopology_LineList = 1,
        WGPUPrimitiveTopology_LineStrip = 2,
        WGPUPrimitiveTopology_TriangleList = 3,
        WGPUPrimitiveTopology_TriangleStrip = 4,
    }
    enum WGPUPrimitiveTopology_PointList = WGPUPrimitiveTopology.WGPUPrimitiveTopology_PointList;
    enum WGPUPrimitiveTopology_LineList = WGPUPrimitiveTopology.WGPUPrimitiveTopology_LineList;
    enum WGPUPrimitiveTopology_LineStrip = WGPUPrimitiveTopology.WGPUPrimitiveTopology_LineStrip;
    enum WGPUPrimitiveTopology_TriangleList = WGPUPrimitiveTopology.WGPUPrimitiveTopology_TriangleList;
    enum WGPUPrimitiveTopology_TriangleStrip = WGPUPrimitiveTopology.WGPUPrimitiveTopology_TriangleStrip;
    enum WGPUSType
    {
        WGPUSType_Invalid = 0,
        WGPUSType_SurfaceDescriptorFromMetalLayer = 1,
        WGPUSType_SurfaceDescriptorFromWindowsHWND = 2,
        WGPUSType_SurfaceDescriptorFromXlib = 3,
        WGPUSType_SurfaceDescriptorFromHTMLCanvasId = 4,
        WGPUSType_ShaderModuleSPIRVDescriptor = 5,
        WGPUSType_ShaderModuleWGSLDescriptor = 6,
        WGPUSType_AnisotropicFiltering = 268435456,
        WGPUSType_Force32 = 2147483647,
    }
    enum WGPUSType_Invalid = WGPUSType.WGPUSType_Invalid;
    enum WGPUSType_SurfaceDescriptorFromMetalLayer = WGPUSType.WGPUSType_SurfaceDescriptorFromMetalLayer;
    enum WGPUSType_SurfaceDescriptorFromWindowsHWND = WGPUSType.WGPUSType_SurfaceDescriptorFromWindowsHWND;
    enum WGPUSType_SurfaceDescriptorFromXlib = WGPUSType.WGPUSType_SurfaceDescriptorFromXlib;
    enum WGPUSType_SurfaceDescriptorFromHTMLCanvasId = WGPUSType.WGPUSType_SurfaceDescriptorFromHTMLCanvasId;
    enum WGPUSType_ShaderModuleSPIRVDescriptor = WGPUSType.WGPUSType_ShaderModuleSPIRVDescriptor;
    enum WGPUSType_ShaderModuleWGSLDescriptor = WGPUSType.WGPUSType_ShaderModuleWGSLDescriptor;
    enum WGPUSType_AnisotropicFiltering = WGPUSType.WGPUSType_AnisotropicFiltering;
    enum WGPUSType_Force32 = WGPUSType.WGPUSType_Force32;
    alias WGPUSType_ = uint;
    enum WGPUStencilOperation
    {
        WGPUStencilOperation_Keep = 0,
        WGPUStencilOperation_Zero = 1,
        WGPUStencilOperation_Replace = 2,
        WGPUStencilOperation_Invert = 3,
        WGPUStencilOperation_IncrementClamp = 4,
        WGPUStencilOperation_DecrementClamp = 5,
        WGPUStencilOperation_IncrementWrap = 6,
        WGPUStencilOperation_DecrementWrap = 7,
    }
    enum WGPUStencilOperation_Keep = WGPUStencilOperation.WGPUStencilOperation_Keep;
    enum WGPUStencilOperation_Zero = WGPUStencilOperation.WGPUStencilOperation_Zero;
    enum WGPUStencilOperation_Replace = WGPUStencilOperation.WGPUStencilOperation_Replace;
    enum WGPUStencilOperation_Invert = WGPUStencilOperation.WGPUStencilOperation_Invert;
    enum WGPUStencilOperation_IncrementClamp = WGPUStencilOperation.WGPUStencilOperation_IncrementClamp;
    enum WGPUStencilOperation_DecrementClamp = WGPUStencilOperation.WGPUStencilOperation_DecrementClamp;
    enum WGPUStencilOperation_IncrementWrap = WGPUStencilOperation.WGPUStencilOperation_IncrementWrap;
    enum WGPUStencilOperation_DecrementWrap = WGPUStencilOperation.WGPUStencilOperation_DecrementWrap;
    enum WGPUStoreOp
    {
        WGPUStoreOp_Clear = 0,
        WGPUStoreOp_Store = 1,
    }
    enum WGPUStoreOp_Clear = WGPUStoreOp.WGPUStoreOp_Clear;
    enum WGPUStoreOp_Store = WGPUStoreOp.WGPUStoreOp_Store;
    enum WGPUSwapChainStatus
    {
        WGPUSwapChainStatus_Good = 0,
        WGPUSwapChainStatus_Suboptimal = 1,
        WGPUSwapChainStatus_Timeout = 2,
        WGPUSwapChainStatus_Outdated = 3,
        WGPUSwapChainStatus_Lost = 4,
        WGPUSwapChainStatus_OutOfMemory = 5,
    }
    enum WGPUSwapChainStatus_Good = WGPUSwapChainStatus.WGPUSwapChainStatus_Good;
    enum WGPUSwapChainStatus_Suboptimal = WGPUSwapChainStatus.WGPUSwapChainStatus_Suboptimal;
    enum WGPUSwapChainStatus_Timeout = WGPUSwapChainStatus.WGPUSwapChainStatus_Timeout;
    enum WGPUSwapChainStatus_Outdated = WGPUSwapChainStatus.WGPUSwapChainStatus_Outdated;
    enum WGPUSwapChainStatus_Lost = WGPUSwapChainStatus.WGPUSwapChainStatus_Lost;
    enum WGPUSwapChainStatus_OutOfMemory = WGPUSwapChainStatus.WGPUSwapChainStatus_OutOfMemory;
    enum WGPUTextureAspect
    {
        WGPUTextureAspect_All = 0,
        WGPUTextureAspect_StencilOnly = 1,
        WGPUTextureAspect_DepthOnly = 2,
    }
    enum WGPUTextureAspect_All = WGPUTextureAspect.WGPUTextureAspect_All;
    enum WGPUTextureAspect_StencilOnly = WGPUTextureAspect.WGPUTextureAspect_StencilOnly;
    enum WGPUTextureAspect_DepthOnly = WGPUTextureAspect.WGPUTextureAspect_DepthOnly;
    enum WGPUTextureComponentType
    {
        WGPUTextureComponentType_Float = 0,
        WGPUTextureComponentType_Sint = 1,
        WGPUTextureComponentType_Uint = 2,
    }
    enum WGPUTextureComponentType_Float = WGPUTextureComponentType.WGPUTextureComponentType_Float;
    enum WGPUTextureComponentType_Sint = WGPUTextureComponentType.WGPUTextureComponentType_Sint;
    enum WGPUTextureComponentType_Uint = WGPUTextureComponentType.WGPUTextureComponentType_Uint;
    enum WGPUTextureDimension
    {
        WGPUTextureDimension_D1 = 0,
        WGPUTextureDimension_D2 = 1,
        WGPUTextureDimension_D3 = 2,
    }
    enum WGPUTextureDimension_D1 = WGPUTextureDimension.WGPUTextureDimension_D1;
    enum WGPUTextureDimension_D2 = WGPUTextureDimension.WGPUTextureDimension_D2;
    enum WGPUTextureDimension_D3 = WGPUTextureDimension.WGPUTextureDimension_D3;
    enum WGPUTextureFormat
    {
        WGPUTextureFormat_R8Unorm = 0,
        WGPUTextureFormat_R8Snorm = 1,
        WGPUTextureFormat_R8Uint = 2,
        WGPUTextureFormat_R8Sint = 3,
        WGPUTextureFormat_R16Uint = 4,
        WGPUTextureFormat_R16Sint = 5,
        WGPUTextureFormat_R16Float = 6,
        WGPUTextureFormat_Rg8Unorm = 7,
        WGPUTextureFormat_Rg8Snorm = 8,
        WGPUTextureFormat_Rg8Uint = 9,
        WGPUTextureFormat_Rg8Sint = 10,
        WGPUTextureFormat_R32Uint = 11,
        WGPUTextureFormat_R32Sint = 12,
        WGPUTextureFormat_R32Float = 13,
        WGPUTextureFormat_Rg16Uint = 14,
        WGPUTextureFormat_Rg16Sint = 15,
        WGPUTextureFormat_Rg16Float = 16,
        WGPUTextureFormat_Rgba8Unorm = 17,
        WGPUTextureFormat_Rgba8UnormSrgb = 18,
        WGPUTextureFormat_Rgba8Snorm = 19,
        WGPUTextureFormat_Rgba8Uint = 20,
        WGPUTextureFormat_Rgba8Sint = 21,
        WGPUTextureFormat_Bgra8Unorm = 22,
        WGPUTextureFormat_Bgra8UnormSrgb = 23,
        WGPUTextureFormat_Rgb10a2Unorm = 24,
        WGPUTextureFormat_Rg11b10Float = 25,
        WGPUTextureFormat_Rg32Uint = 26,
        WGPUTextureFormat_Rg32Sint = 27,
        WGPUTextureFormat_Rg32Float = 28,
        WGPUTextureFormat_Rgba16Uint = 29,
        WGPUTextureFormat_Rgba16Sint = 30,
        WGPUTextureFormat_Rgba16Float = 31,
        WGPUTextureFormat_Rgba32Uint = 32,
        WGPUTextureFormat_Rgba32Sint = 33,
        WGPUTextureFormat_Rgba32Float = 34,
        WGPUTextureFormat_Depth32Float = 35,
        WGPUTextureFormat_Depth24Plus = 36,
        WGPUTextureFormat_Depth24PlusStencil8 = 37,
    }
    enum WGPUTextureFormat_R8Unorm = WGPUTextureFormat.WGPUTextureFormat_R8Unorm;
    enum WGPUTextureFormat_R8Snorm = WGPUTextureFormat.WGPUTextureFormat_R8Snorm;
    enum WGPUTextureFormat_R8Uint = WGPUTextureFormat.WGPUTextureFormat_R8Uint;
    enum WGPUTextureFormat_R8Sint = WGPUTextureFormat.WGPUTextureFormat_R8Sint;
    enum WGPUTextureFormat_R16Uint = WGPUTextureFormat.WGPUTextureFormat_R16Uint;
    enum WGPUTextureFormat_R16Sint = WGPUTextureFormat.WGPUTextureFormat_R16Sint;
    enum WGPUTextureFormat_R16Float = WGPUTextureFormat.WGPUTextureFormat_R16Float;
    enum WGPUTextureFormat_Rg8Unorm = WGPUTextureFormat.WGPUTextureFormat_Rg8Unorm;
    enum WGPUTextureFormat_Rg8Snorm = WGPUTextureFormat.WGPUTextureFormat_Rg8Snorm;
    enum WGPUTextureFormat_Rg8Uint = WGPUTextureFormat.WGPUTextureFormat_Rg8Uint;
    enum WGPUTextureFormat_Rg8Sint = WGPUTextureFormat.WGPUTextureFormat_Rg8Sint;
    enum WGPUTextureFormat_R32Uint = WGPUTextureFormat.WGPUTextureFormat_R32Uint;
    enum WGPUTextureFormat_R32Sint = WGPUTextureFormat.WGPUTextureFormat_R32Sint;
    enum WGPUTextureFormat_R32Float = WGPUTextureFormat.WGPUTextureFormat_R32Float;
    enum WGPUTextureFormat_Rg16Uint = WGPUTextureFormat.WGPUTextureFormat_Rg16Uint;
    enum WGPUTextureFormat_Rg16Sint = WGPUTextureFormat.WGPUTextureFormat_Rg16Sint;
    enum WGPUTextureFormat_Rg16Float = WGPUTextureFormat.WGPUTextureFormat_Rg16Float;
    enum WGPUTextureFormat_Rgba8Unorm = WGPUTextureFormat.WGPUTextureFormat_Rgba8Unorm;
    enum WGPUTextureFormat_Rgba8UnormSrgb = WGPUTextureFormat.WGPUTextureFormat_Rgba8UnormSrgb;
    enum WGPUTextureFormat_Rgba8Snorm = WGPUTextureFormat.WGPUTextureFormat_Rgba8Snorm;
    enum WGPUTextureFormat_Rgba8Uint = WGPUTextureFormat.WGPUTextureFormat_Rgba8Uint;
    enum WGPUTextureFormat_Rgba8Sint = WGPUTextureFormat.WGPUTextureFormat_Rgba8Sint;
    enum WGPUTextureFormat_Bgra8Unorm = WGPUTextureFormat.WGPUTextureFormat_Bgra8Unorm;
    enum WGPUTextureFormat_Bgra8UnormSrgb = WGPUTextureFormat.WGPUTextureFormat_Bgra8UnormSrgb;
    enum WGPUTextureFormat_Rgb10a2Unorm = WGPUTextureFormat.WGPUTextureFormat_Rgb10a2Unorm;
    enum WGPUTextureFormat_Rg11b10Float = WGPUTextureFormat.WGPUTextureFormat_Rg11b10Float;
    enum WGPUTextureFormat_Rg32Uint = WGPUTextureFormat.WGPUTextureFormat_Rg32Uint;
    enum WGPUTextureFormat_Rg32Sint = WGPUTextureFormat.WGPUTextureFormat_Rg32Sint;
    enum WGPUTextureFormat_Rg32Float = WGPUTextureFormat.WGPUTextureFormat_Rg32Float;
    enum WGPUTextureFormat_Rgba16Uint = WGPUTextureFormat.WGPUTextureFormat_Rgba16Uint;
    enum WGPUTextureFormat_Rgba16Sint = WGPUTextureFormat.WGPUTextureFormat_Rgba16Sint;
    enum WGPUTextureFormat_Rgba16Float = WGPUTextureFormat.WGPUTextureFormat_Rgba16Float;
    enum WGPUTextureFormat_Rgba32Uint = WGPUTextureFormat.WGPUTextureFormat_Rgba32Uint;
    enum WGPUTextureFormat_Rgba32Sint = WGPUTextureFormat.WGPUTextureFormat_Rgba32Sint;
    enum WGPUTextureFormat_Rgba32Float = WGPUTextureFormat.WGPUTextureFormat_Rgba32Float;
    enum WGPUTextureFormat_Depth32Float = WGPUTextureFormat.WGPUTextureFormat_Depth32Float;
    enum WGPUTextureFormat_Depth24Plus = WGPUTextureFormat.WGPUTextureFormat_Depth24Plus;
    enum WGPUTextureFormat_Depth24PlusStencil8 = WGPUTextureFormat.WGPUTextureFormat_Depth24PlusStencil8;
    enum WGPUTextureViewDimension
    {
        WGPUTextureViewDimension_D1 = 0,
        WGPUTextureViewDimension_D2 = 1,
        WGPUTextureViewDimension_D2Array = 2,
        WGPUTextureViewDimension_Cube = 3,
        WGPUTextureViewDimension_CubeArray = 4,
        WGPUTextureViewDimension_D3 = 5,
    }
    enum WGPUTextureViewDimension_D1 = WGPUTextureViewDimension.WGPUTextureViewDimension_D1;
    enum WGPUTextureViewDimension_D2 = WGPUTextureViewDimension.WGPUTextureViewDimension_D2;
    enum WGPUTextureViewDimension_D2Array = WGPUTextureViewDimension.WGPUTextureViewDimension_D2Array;
    enum WGPUTextureViewDimension_Cube = WGPUTextureViewDimension.WGPUTextureViewDimension_Cube;
    enum WGPUTextureViewDimension_CubeArray = WGPUTextureViewDimension.WGPUTextureViewDimension_CubeArray;
    enum WGPUTextureViewDimension_D3 = WGPUTextureViewDimension.WGPUTextureViewDimension_D3;
    enum WGPUVertexFormat
    {
        WGPUVertexFormat_Uchar2 = 0,
        WGPUVertexFormat_Uchar4 = 1,
        WGPUVertexFormat_Char2 = 2,
        WGPUVertexFormat_Char4 = 3,
        WGPUVertexFormat_Uchar2Norm = 4,
        WGPUVertexFormat_Uchar4Norm = 5,
        WGPUVertexFormat_Char2Norm = 6,
        WGPUVertexFormat_Char4Norm = 7,
        WGPUVertexFormat_Ushort2 = 8,
        WGPUVertexFormat_Ushort4 = 9,
        WGPUVertexFormat_Short2 = 10,
        WGPUVertexFormat_Short4 = 11,
        WGPUVertexFormat_Ushort2Norm = 12,
        WGPUVertexFormat_Ushort4Norm = 13,
        WGPUVertexFormat_Short2Norm = 14,
        WGPUVertexFormat_Short4Norm = 15,
        WGPUVertexFormat_Half2 = 16,
        WGPUVertexFormat_Half4 = 17,
        WGPUVertexFormat_Float = 18,
        WGPUVertexFormat_Float2 = 19,
        WGPUVertexFormat_Float3 = 20,
        WGPUVertexFormat_Float4 = 21,
        WGPUVertexFormat_Uint = 22,
        WGPUVertexFormat_Uint2 = 23,
        WGPUVertexFormat_Uint3 = 24,
        WGPUVertexFormat_Uint4 = 25,
        WGPUVertexFormat_Int = 26,
        WGPUVertexFormat_Int2 = 27,
        WGPUVertexFormat_Int3 = 28,
        WGPUVertexFormat_Int4 = 29,
    }
    enum WGPUVertexFormat_Uchar2 = WGPUVertexFormat.WGPUVertexFormat_Uchar2;
    enum WGPUVertexFormat_Uchar4 = WGPUVertexFormat.WGPUVertexFormat_Uchar4;
    enum WGPUVertexFormat_Char2 = WGPUVertexFormat.WGPUVertexFormat_Char2;
    enum WGPUVertexFormat_Char4 = WGPUVertexFormat.WGPUVertexFormat_Char4;
    enum WGPUVertexFormat_Uchar2Norm = WGPUVertexFormat.WGPUVertexFormat_Uchar2Norm;
    enum WGPUVertexFormat_Uchar4Norm = WGPUVertexFormat.WGPUVertexFormat_Uchar4Norm;
    enum WGPUVertexFormat_Char2Norm = WGPUVertexFormat.WGPUVertexFormat_Char2Norm;
    enum WGPUVertexFormat_Char4Norm = WGPUVertexFormat.WGPUVertexFormat_Char4Norm;
    enum WGPUVertexFormat_Ushort2 = WGPUVertexFormat.WGPUVertexFormat_Ushort2;
    enum WGPUVertexFormat_Ushort4 = WGPUVertexFormat.WGPUVertexFormat_Ushort4;
    enum WGPUVertexFormat_Short2 = WGPUVertexFormat.WGPUVertexFormat_Short2;
    enum WGPUVertexFormat_Short4 = WGPUVertexFormat.WGPUVertexFormat_Short4;
    enum WGPUVertexFormat_Ushort2Norm = WGPUVertexFormat.WGPUVertexFormat_Ushort2Norm;
    enum WGPUVertexFormat_Ushort4Norm = WGPUVertexFormat.WGPUVertexFormat_Ushort4Norm;
    enum WGPUVertexFormat_Short2Norm = WGPUVertexFormat.WGPUVertexFormat_Short2Norm;
    enum WGPUVertexFormat_Short4Norm = WGPUVertexFormat.WGPUVertexFormat_Short4Norm;
    enum WGPUVertexFormat_Half2 = WGPUVertexFormat.WGPUVertexFormat_Half2;
    enum WGPUVertexFormat_Half4 = WGPUVertexFormat.WGPUVertexFormat_Half4;
    enum WGPUVertexFormat_Float = WGPUVertexFormat.WGPUVertexFormat_Float;
    enum WGPUVertexFormat_Float2 = WGPUVertexFormat.WGPUVertexFormat_Float2;
    enum WGPUVertexFormat_Float3 = WGPUVertexFormat.WGPUVertexFormat_Float3;
    enum WGPUVertexFormat_Float4 = WGPUVertexFormat.WGPUVertexFormat_Float4;
    enum WGPUVertexFormat_Uint = WGPUVertexFormat.WGPUVertexFormat_Uint;
    enum WGPUVertexFormat_Uint2 = WGPUVertexFormat.WGPUVertexFormat_Uint2;
    enum WGPUVertexFormat_Uint3 = WGPUVertexFormat.WGPUVertexFormat_Uint3;
    enum WGPUVertexFormat_Uint4 = WGPUVertexFormat.WGPUVertexFormat_Uint4;
    enum WGPUVertexFormat_Int = WGPUVertexFormat.WGPUVertexFormat_Int;
    enum WGPUVertexFormat_Int2 = WGPUVertexFormat.WGPUVertexFormat_Int2;
    enum WGPUVertexFormat_Int3 = WGPUVertexFormat.WGPUVertexFormat_Int3;
    enum WGPUVertexFormat_Int4 = WGPUVertexFormat.WGPUVertexFormat_Int4;
    struct WGPUComputePass;
    // https://docs.piston.rs/conrod/wgpu_types/type.BufferSize.html
    /// Integral type used for buffer slice sizes.
    alias WGPUOption_BufferSize = uint64_t;
    struct WGPURenderBundleEncoder;
    struct WGPURenderPass;
    alias WGPUId_Adapter_Dummy = ulong;
    alias WGPUAdapterId = ulong;
    alias WGPUFeatures = c_ulong;
    alias uint64_t = ulong;
    alias uint32_t = uint;
    alias uint16_t = ushort;
    alias uint8_t = ubyte;
    alias int64_t = c_long;
    alias int32_t = int;
    struct WGPUCAdapterInfo
    {
        char* name;
        c_ulong name_length;
        c_ulong vendor;
        c_ulong device;
        ubyte device_type;
        ubyte backend;
    }
    struct WGPUCLimits
    {
        uint max_bind_groups;
    }
    alias WGPUId_Device_Dummy = ulong;
    alias WGPUDeviceId = ulong;
    alias WGPUId_BindGroup_Dummy = ulong;
    alias WGPUBindGroupId = ulong;
    alias WGPUId_BindGroupLayout_Dummy = ulong;
    alias WGPUBindGroupLayoutId = ulong;
    alias WGPUId_Buffer_Dummy = ulong;
    alias WGPUBufferId = ulong;
    alias WGPUBufferAddress = c_ulong;
    alias WGPUBufferSize = ulong;
    alias WGPUBufferMapCallback = void function(WGPUBufferMapAsyncStatus, ubyte*);
    alias WGPUId_CommandBuffer_Dummy = ulong;
    alias WGPUCommandBufferId = ulong;
    alias WGPUCommandEncoderId = ulong;
    struct WGPUComputePassDescriptor
    {
        uint todo;
    }
    alias WGPUId_TextureView_Dummy = ulong;
    alias WGPUTextureViewId = ulong;
    struct WGPUColor
    {
        double r;
        double g;
        double b;
        double a;
    }
    alias int16_t = short;
    alias int8_t = byte;
    struct WGPUPassChannel_Color
    {
        WGPULoadOp load_op;
        WGPUStoreOp store_op;
        WGPUColor clear_value;
        bool read_only;
    }
    struct WGPURenderPassColorAttachmentDescriptorBase_TextureViewId
    {
        ulong attachment;
        ulong resolve_target;
        WGPUPassChannel_Color channel;
    }
    alias WGPURenderPassColorAttachmentDescriptor = WGPURenderPassColorAttachmentDescriptorBase_TextureViewId;
    struct WGPUPassChannel_f32
    {
        WGPULoadOp load_op;
        WGPUStoreOp store_op;
        float clear_value;
        bool read_only;
    }
    struct WGPUPassChannel_u32
    {
        WGPULoadOp load_op;
        WGPUStoreOp store_op;
        uint clear_value;
        bool read_only;
    }
    struct WGPURenderPassDepthStencilAttachmentDescriptorBase_TextureViewId
    {
        ulong attachment;
        WGPUPassChannel_f32 depth;
        WGPUPassChannel_u32 stencil;
    }
    alias WGPURenderPassDepthStencilAttachmentDescriptor = WGPURenderPassDepthStencilAttachmentDescriptorBase_TextureViewId;
    struct WGPURenderPassDescriptor
    {
        const(WGPURenderPassColorAttachmentDescriptorBase_TextureViewId)* color_attachments;
        c_ulong color_attachments_length;
        const(WGPURenderPassDepthStencilAttachmentDescriptorBase_TextureViewId)* depth_stencil_attachment;
    }
    struct WGPUTextureDataLayout
    {
        c_ulong offset;
        uint bytes_per_row;
        uint rows_per_image;
    }
    struct WGPUBufferCopyView
    {
        ulong buffer;
        WGPUTextureDataLayout layout;
    }
    alias WGPUId_Texture_Dummy = ulong;
    alias WGPUTextureId = ulong;
    struct WGPUOrigin3d
    {
        uint x;
        uint y;
        uint z;
    }
    struct WGPUTextureCopyView
    {
        ulong texture;
        uint mip_level;
        WGPUOrigin3d origin;
    }
    struct WGPUExtent3d
    {
        uint width;
        uint height;
        uint depth;
    }
    struct WGPUCommandBufferDescriptor
    {
        uint todo;
    }
    alias WGPURawString = const(char)*;
    alias WGPUDynamicOffset = uint;
    alias WGPUId_ComputePipeline_Dummy = ulong;
    alias WGPUComputePipelineId = ulong;
    alias WGPUId_Surface = ulong;
    alias WGPUSurfaceId = ulong;
    alias WGPULabel = const(char)*;
    struct WGPUBindGroupEntry
    {
        uint binding;
        ulong buffer;
        c_ulong offset;
        ulong size;
        ulong sampler;
        ulong texture_view;
    }
    struct WGPUBindGroupDescriptor
    {
        const(char)* label;
        ulong layout;
        const(WGPUBindGroupEntry)* entries;
        c_ulong entries_length;
    }
    alias WGPUShaderStage = uint;
    union pthread_barrierattr_t
    {
        char[4] __size;
        int __align;
    }
    struct WGPUBindGroupLayoutEntry
    {
        uint binding;
        uint visibility;
        uint ty;
        bool has_dynamic_offset;
        c_ulong min_buffer_binding_size;
        bool multisampled;
        WGPUTextureViewDimension view_dimension;
        WGPUTextureComponentType texture_component_type;
        WGPUTextureFormat storage_texture_format;
        c_ulong count;
    }
    struct WGPUBindGroupLayoutDescriptor
    {
        const(char)* label;
        const(WGPUBindGroupLayoutEntry)* entries;
        c_ulong entries_length;
    }
    alias WGPUBufferUsage = uint;
    union pthread_barrier_t
    {
        char[32] __size;
        c_long __align;
    }
    alias pthread_spinlock_t = int;
    union pthread_rwlockattr_t
    {
        char[8] __size;
        c_long __align;
    }
    struct WGPUBufferDescriptor
    {
        const(char)* label;
        c_ulong size;
        uint usage;
        bool mapped_at_creation;
    }
    struct WGPUCommandEncoderDescriptor
    {
        const(char)* label;
    }
    alias WGPUId_PipelineLayout_Dummy = ulong;
    alias WGPUPipelineLayoutId = ulong;
    alias WGPUId_ShaderModule_Dummy = ulong;
    alias WGPUShaderModuleId = ulong;
    struct WGPUProgrammableStageDescriptor
    {
        ulong module_;
        const(char)* entry_point;
    }
    struct WGPUComputePipelineDescriptor
    {
        ulong layout;
        WGPUProgrammableStageDescriptor compute_stage;
    }
    struct WGPUPipelineLayoutDescriptor
    {
        const(ulong)* bind_group_layouts;
        c_ulong bind_group_layouts_length;
    }
    alias WGPURenderBundleEncoderId = WGPURenderBundleEncoder*;
    struct WGPURenderBundleEncoderDescriptor
    {
        const(char)* label;
        const(WGPUTextureFormat)* color_formats;
        c_ulong color_formats_length;
        const(WGPUTextureFormat)* depth_stencil_format;
        uint sample_count;
    }
    alias WGPUId_RenderPipeline_Dummy = ulong;
    alias WGPURenderPipelineId = ulong;
    struct WGPURasterizationStateDescriptor
    {
        WGPUFrontFace front_face;
        WGPUCullMode cull_mode;
        int depth_bias;
        float depth_bias_slope_scale;
        float depth_bias_clamp;
    }
    struct WGPUBlendDescriptor
    {
        WGPUBlendFactor src_factor;
        WGPUBlendFactor dst_factor;
        WGPUBlendOperation operation;
    }
    alias WGPUColorWrite = uint;
    union pthread_rwlock_t
    {
        __pthread_rwlock_arch_t __data;
        char[56] __size;
        c_long __align;
    }
    union pthread_cond_t
    {
        __pthread_cond_s __data;
        char[48] __size;
        long __align;
    }
    struct WGPUColorStateDescriptor
    {
        WGPUTextureFormat format;
        WGPUBlendDescriptor alpha_blend;
        WGPUBlendDescriptor color_blend;
        uint write_mask;
    }
    struct WGPUStencilStateFaceDescriptor
    {
        WGPUCompareFunction compare;
        WGPUStencilOperation fail_op;
        WGPUStencilOperation depth_fail_op;
        WGPUStencilOperation pass_op;
    }
    struct WGPUDepthStencilStateDescriptor
    {
        WGPUTextureFormat format;
        bool depth_write_enabled;
        WGPUCompareFunction depth_compare;
        WGPUStencilStateFaceDescriptor stencil_front;
        WGPUStencilStateFaceDescriptor stencil_back;
        uint stencil_read_mask;
        uint stencil_write_mask;
    }
    alias WGPUShaderLocation = uint;
    struct WGPUVertexAttributeDescriptor
    {
        c_ulong offset;
        WGPUVertexFormat format;
        uint shader_location;
    }
    struct WGPUVertexBufferLayoutDescriptor
    {
        c_ulong array_stride;
        WGPUInputStepMode step_mode;
        const(WGPUVertexAttributeDescriptor)* attributes;
        c_ulong attributes_length;
    }
    struct WGPUVertexStateDescriptor
    {
        WGPUIndexFormat index_format;
        const(WGPUVertexBufferLayoutDescriptor)* vertex_buffers;
        c_ulong vertex_buffers_length;
    }
    struct WGPURenderPipelineDescriptor
    {
        ulong layout;
        WGPUProgrammableStageDescriptor vertex_stage;
        const(WGPUProgrammableStageDescriptor)* fragment_stage;
        WGPUPrimitiveTopology primitive_topology;
        const(WGPURasterizationStateDescriptor)* rasterization_state;
        const(WGPUColorStateDescriptor)* color_states;
        c_ulong color_states_length;
        const(WGPUDepthStencilStateDescriptor)* depth_stencil_state;
        WGPUVertexStateDescriptor vertex_state;
        uint sample_count;
        uint sample_mask;
        bool alpha_to_coverage_enabled;
    }
    alias WGPUId_Sampler_Dummy = ulong;
    alias WGPUSamplerId = ulong;
    struct WGPUSamplerDescriptor
    {
        const(WGPUChainedStruct)* next_in_chain;
        const(char)* label;
        WGPUAddressMode address_mode_u;
        WGPUAddressMode address_mode_v;
        WGPUAddressMode address_mode_w;
        WGPUFilterMode mag_filter;
        WGPUFilterMode min_filter;
        WGPUFilterMode mipmap_filter;
        float lod_min_clamp;
        float lod_max_clamp;
        WGPUCompareFunction compare;
    }
    struct WGPUShaderSource
    {
        const(uint)* bytes;
        c_ulong length;
    }
    alias WGPUId_SwapChain_Dummy = ulong;
    alias WGPUSwapChainId = ulong;
    alias WGPUTextureUsage = uint;
    union pthread_mutex_t
    {
        __pthread_mutex_s __data;
        char[40] __size;
        c_long __align;
    }
    struct WGPUSwapChainDescriptor
    {
        uint usage;
        WGPUTextureFormat format;
        uint width;
        uint height;
        WGPUPresentMode present_mode;
    }
    struct WGPUTextureDescriptor
    {
        const(char)* label;
        WGPUExtent3d size;
        uint mip_level_count;
        uint sample_count;
        WGPUTextureDimension dimension;
        WGPUTextureFormat format;
        uint usage;
    }
    alias WGPUQueueId = ulong;
    alias WGPUId_RenderBundle = ulong;
    alias WGPURenderBundleId = ulong;
    struct WGPURenderBundleDescriptor_Label
    {
        const(char)* label;
    }
    struct WGPURequestAdapterOptions
    {
        WGPUPowerPreference power_preference;
        ulong compatible_surface;
    }
    alias WGPUBackendBit = uint;
    alias WGPURequestAdapterCallback = void function(ulong, void*);
    alias WGPULogCallback = void function(int, const(char)*);
    struct WGPUSwapChainOutput
    {
        WGPUSwapChainStatus status;
        ulong view_id;
    }
    struct WGPUTextureViewDescriptor
    {
        const(char)* label;
        WGPUTextureFormat format;
        WGPUTextureViewDimension dimension;
        WGPUTextureAspect aspect;
        uint base_mip_level;
        uint level_count;
        uint base_array_layer;
        uint array_layer_count;
    }
    struct WGPUAnisotropicSamplerDescriptorExt
    {
        const(WGPUChainedStruct)* next_in_chain;
        uint s_type;
        ubyte anisotropic_clamp;
    }
    void wgpu_adapter_destroy(ulong) @nogc nothrow;
    c_ulong wgpu_adapter_features(ulong) @nogc nothrow;
    void wgpu_adapter_get_info(ulong, WGPUCAdapterInfo*) @nogc nothrow;
    WGPUCLimits wgpu_adapter_limits(ulong) @nogc nothrow;
    ulong wgpu_adapter_request_device(ulong, c_ulong, const(WGPUCLimits)*, bool, const(char)*) @nogc nothrow;
    void wgpu_bind_group_destroy(ulong) @nogc nothrow;
    void wgpu_bind_group_layout_destroy(ulong) @nogc nothrow;
    void wgpu_buffer_destroy(ulong) @nogc nothrow;
    ubyte* wgpu_buffer_get_mapped_range(ulong, c_ulong, ulong) @nogc nothrow;
    void wgpu_buffer_map_read_async(ulong, c_ulong, c_ulong, void function(WGPUBufferMapAsyncStatus, ubyte*), ubyte*) @nogc nothrow;
    void wgpu_buffer_map_write_async(ulong, c_ulong, c_ulong, void function(WGPUBufferMapAsyncStatus, ubyte*), ubyte*) @nogc nothrow;
    void wgpu_buffer_unmap(ulong) @nogc nothrow;
    void wgpu_command_buffer_destroy(ulong) @nogc nothrow;
    WGPUComputePass* wgpu_command_encoder_begin_compute_pass(ulong, const(WGPUComputePassDescriptor)*) @nogc nothrow;
    WGPURenderPass* wgpu_command_encoder_begin_render_pass(ulong, const(WGPURenderPassDescriptor)*) @nogc nothrow;
    void wgpu_command_encoder_copy_buffer_to_buffer(ulong, ulong, c_ulong, ulong, c_ulong, c_ulong) @nogc nothrow;
    void wgpu_command_encoder_copy_buffer_to_texture(ulong, const(WGPUBufferCopyView)*, const(WGPUTextureCopyView)*, const(WGPUExtent3d)*) @nogc nothrow;
    void wgpu_command_encoder_copy_texture_to_buffer(ulong, const(WGPUTextureCopyView)*, const(WGPUBufferCopyView)*, const(WGPUExtent3d)*) @nogc nothrow;
    void wgpu_command_encoder_copy_texture_to_texture(ulong, const(WGPUTextureCopyView)*, const(WGPUTextureCopyView)*, const(WGPUExtent3d)*) @nogc nothrow;
    void wgpu_command_encoder_destroy(ulong) @nogc nothrow;
    ulong wgpu_command_encoder_finish(ulong, const(WGPUCommandBufferDescriptor)*) @nogc nothrow;
    void wgpu_compute_pass_destroy(WGPUComputePass*) @nogc nothrow;
    void wgpu_compute_pass_dispatch(WGPUComputePass*, uint, uint, uint) @nogc nothrow;
    void wgpu_compute_pass_dispatch_indirect(WGPUComputePass*, ulong, c_ulong) @nogc nothrow;
    void wgpu_compute_pass_end_pass(WGPUComputePass*) @nogc nothrow;
    void wgpu_compute_pass_insert_debug_marker(WGPUComputePass*, const(char)*, uint) @nogc nothrow;
    void wgpu_compute_pass_pop_debug_group(WGPUComputePass*) @nogc nothrow;
    void wgpu_compute_pass_push_debug_group(WGPUComputePass*, const(char)*, uint) @nogc nothrow;
    void wgpu_compute_pass_set_bind_group(WGPUComputePass*, uint, ulong, const(uint)*, c_ulong) @nogc nothrow;
    void wgpu_compute_pass_set_pipeline(WGPUComputePass*, ulong) @nogc nothrow;
    void wgpu_compute_pipeline_destroy(ulong) @nogc nothrow;
    ulong wgpu_create_surface_from_android(void*) @nogc nothrow;
    ulong wgpu_create_surface_from_metal_layer(void*) @nogc nothrow;
    ulong wgpu_create_surface_from_wayland(void*, void*) @nogc nothrow;
    ulong wgpu_create_surface_from_windows_hwnd(void*, void*) @nogc nothrow;
    ulong wgpu_create_surface_from_xlib(const(void)**, c_ulong) @nogc nothrow;
    ulong wgpu_device_create_bind_group(ulong, const(WGPUBindGroupDescriptor)*) @nogc nothrow;
    ulong wgpu_device_create_bind_group_layout(ulong, const(WGPUBindGroupLayoutDescriptor)*) @nogc nothrow;
    ulong wgpu_device_create_buffer(ulong, const(WGPUBufferDescriptor)*) @nogc nothrow;
    ulong wgpu_device_create_command_encoder(ulong, const(WGPUCommandEncoderDescriptor)*) @nogc nothrow;
    ulong wgpu_device_create_compute_pipeline(ulong, const(WGPUComputePipelineDescriptor)*) @nogc nothrow;
    ulong wgpu_device_create_pipeline_layout(ulong, const(WGPUPipelineLayoutDescriptor)*) @nogc nothrow;
    WGPURenderBundleEncoder* wgpu_device_create_render_bundle_encoder(ulong, const(WGPURenderBundleEncoderDescriptor)*) @nogc nothrow;
    ulong wgpu_device_create_render_pipeline(ulong, const(WGPURenderPipelineDescriptor)*) @nogc nothrow;
    ulong wgpu_device_create_sampler(ulong, const(WGPUSamplerDescriptor)*) @nogc nothrow;
    ulong wgpu_device_create_shader_module(ulong, WGPUShaderSource) @nogc nothrow;
    ulong wgpu_device_create_swap_chain(ulong, ulong, const(WGPUSwapChainDescriptor)*) @nogc nothrow;
    ulong wgpu_device_create_texture(ulong, const(WGPUTextureDescriptor)*) @nogc nothrow;
    void wgpu_device_destroy(ulong) @nogc nothrow;
    c_ulong wgpu_device_features(ulong) @nogc nothrow;
    ulong wgpu_device_get_default_queue(ulong) @nogc nothrow;
    WGPUCLimits wgpu_device_limits(ulong) @nogc nothrow;
    void wgpu_device_poll(ulong, bool) @nogc nothrow;
    uint wgpu_get_version() @nogc nothrow;
    void wgpu_pipeline_layout_destroy(ulong) @nogc nothrow;
    void wgpu_queue_submit(ulong, const(ulong)*, c_ulong) @nogc nothrow;
    void wgpu_queue_write_buffer(ulong, ulong, c_ulong, const(ubyte)*, c_ulong) @nogc nothrow;
    void wgpu_queue_write_texture(ulong, const(WGPUTextureCopyView)*, const(ubyte)*, c_ulong, const(WGPUTextureDataLayout)*, const(WGPUExtent3d)*) @nogc nothrow;
    void wgpu_render_bundle_destroy(ulong) @nogc nothrow;
    void wgpu_render_bundle_draw(WGPURenderBundleEncoder*, uint, uint, uint, uint) @nogc nothrow;
    void wgpu_render_bundle_draw_indexed(WGPURenderBundleEncoder*, uint, uint, uint, int, uint) @nogc nothrow;
    void wgpu_render_bundle_draw_indirect(WGPURenderBundleEncoder*, ulong, c_ulong) @nogc nothrow;
    ulong wgpu_render_bundle_encoder_finish(WGPURenderBundleEncoder*, const(WGPURenderBundleDescriptor_Label)*) @nogc nothrow;
    void wgpu_render_bundle_insert_debug_marker(WGPURenderBundleEncoder*, const(char)*) @nogc nothrow;
    void wgpu_render_bundle_pop_debug_group(WGPURenderBundleEncoder*) @nogc nothrow;
    void wgpu_render_bundle_push_debug_group(WGPURenderBundleEncoder*, const(char)*) @nogc nothrow;
    void wgpu_render_bundle_set_bind_group(WGPURenderBundleEncoder*, uint, ulong, const(uint)*, c_ulong) @nogc nothrow;
    void wgpu_render_bundle_set_index_buffer(WGPURenderBundleEncoder*, ulong, c_ulong, WGPUOption_BufferSize) @nogc nothrow;
    void wgpu_render_bundle_set_pipeline(WGPURenderBundleEncoder*, ulong) @nogc nothrow;
    void wgpu_render_bundle_set_vertex_buffer(WGPURenderBundleEncoder*, uint, ulong, c_ulong, WGPUOption_BufferSize) @nogc nothrow;
    void wgpu_render_pass_bundle_indexed_indirect(WGPURenderBundleEncoder*, ulong, c_ulong) @nogc nothrow;
    void wgpu_render_pass_destroy(WGPURenderPass*) @nogc nothrow;
    void wgpu_render_pass_draw(WGPURenderPass*, uint, uint, uint, uint) @nogc nothrow;
    void wgpu_render_pass_draw_indexed(WGPURenderPass*, uint, uint, uint, int, uint) @nogc nothrow;
    void wgpu_render_pass_draw_indexed_indirect(WGPURenderPass*, ulong, c_ulong) @nogc nothrow;
    void wgpu_render_pass_draw_indirect(WGPURenderPass*, ulong, c_ulong) @nogc nothrow;
    void wgpu_render_pass_end_pass(WGPURenderPass*) @nogc nothrow;
    void wgpu_render_pass_insert_debug_marker(WGPURenderPass*, const(char)*, uint) @nogc nothrow;
    void wgpu_render_pass_multi_draw_indexed_indirect(WGPURenderPass*, ulong, c_ulong, uint) @nogc nothrow;
    void wgpu_render_pass_multi_draw_indexed_indirect_count(WGPURenderPass*, ulong, c_ulong, ulong, c_ulong, uint) @nogc nothrow;
    void wgpu_render_pass_multi_draw_indirect(WGPURenderPass*, ulong, c_ulong, uint) @nogc nothrow;
    void wgpu_render_pass_multi_draw_indirect_count(WGPURenderPass*, ulong, c_ulong, ulong, c_ulong, uint) @nogc nothrow;
    void wgpu_render_pass_pop_debug_group(WGPURenderPass*) @nogc nothrow;
    void wgpu_render_pass_push_debug_group(WGPURenderPass*, const(char)*, uint) @nogc nothrow;
    void wgpu_render_pass_set_bind_group(WGPURenderPass*, uint, ulong, const(uint)*, c_ulong) @nogc nothrow;
    void wgpu_render_pass_set_blend_color(WGPURenderPass*, const(WGPUColor)*) @nogc nothrow;
    void wgpu_render_pass_set_index_buffer(WGPURenderPass*, ulong, c_ulong, WGPUOption_BufferSize) @nogc nothrow;
    void wgpu_render_pass_set_pipeline(WGPURenderPass*, ulong) @nogc nothrow;
    void wgpu_render_pass_set_scissor_rect(WGPURenderPass*, uint, uint, uint, uint) @nogc nothrow;
    void wgpu_render_pass_set_stencil_reference(WGPURenderPass*, uint) @nogc nothrow;
    void wgpu_render_pass_set_vertex_buffer(WGPURenderPass*, uint, ulong, c_ulong, WGPUOption_BufferSize) @nogc nothrow;
    void wgpu_render_pass_set_viewport(WGPURenderPass*, float, float, float, float, float, float) @nogc nothrow;
    void wgpu_render_pipeline_destroy(ulong) @nogc nothrow;
    void wgpu_request_adapter_async(const(WGPURequestAdapterOptions)*, uint, bool, void function(ulong, void*), void*) @nogc nothrow;
    void wgpu_sampler_destroy(ulong) @nogc nothrow;
    void wgpu_set_log_callback(void function(int, const(char)*)) @nogc nothrow;
    int wgpu_set_log_level(WGPULogLevel) @nogc nothrow;
    void wgpu_shader_module_destroy(ulong) @nogc nothrow;
    WGPUSwapChainOutput wgpu_swap_chain_get_next_texture(ulong) @nogc nothrow;
    void wgpu_swap_chain_present(ulong) @nogc nothrow;
    ulong wgpu_texture_create_view(ulong, const(WGPUTextureViewDescriptor)*) @nogc nothrow;
    void wgpu_texture_destroy(ulong) @nogc nothrow;
    void wgpu_texture_view_destroy(ulong) @nogc nothrow;
    union pthread_attr_t
    {
        char[56] __size;
        c_long __align;
    }
    pragma(mangle, "alloca") void* alloca_(c_ulong) @nogc nothrow;
    alias pthread_once_t = int;
    alias pthread_key_t = uint;
    union pthread_condattr_t
    {
        char[4] __size;
        int __align;
    }
    union pthread_mutexattr_t
    {
        char[4] __size;
        int __align;
    }
    alias pthread_t = c_ulong;
    struct __pthread_rwlock_arch_t
    {
        uint __readers;
        uint __writers;
        uint __wrphase_futex;
        uint __writers_futex;
        uint __pad3;
        uint __pad4;
        int __cur_writer;
        int __shared;
        byte __rwelision;
        ubyte[7] __pad1;
        c_ulong __pad2;
        uint __flags;
    }
    alias size_t = c_ulong;
    alias wchar_t = int;
    alias _Float64x = real;
    alias _Float32x = double;
    alias _Float64 = double;
    alias _Float32 = float;
    alias int_least8_t = byte;
    alias int_least16_t = short;
    alias int_least32_t = int;
    alias int_least64_t = c_long;
    alias uint_least8_t = ubyte;
    alias uint_least16_t = ushort;
    alias uint_least32_t = uint;
    alias uint_least64_t = c_ulong;
    alias int_fast8_t = byte;
    alias int_fast16_t = c_long;
    alias int_fast32_t = c_long;
    alias int_fast64_t = c_long;
    alias uint_fast8_t = ubyte;
    alias uint_fast16_t = c_ulong;
    alias uint_fast32_t = c_ulong;
    alias uint_fast64_t = c_ulong;
    alias intptr_t = c_long;
    alias uintptr_t = c_ulong;
    alias intmax_t = c_long;
    alias uintmax_t = c_ulong;
    int getloadavg(double*, int) @nogc nothrow;
    int getsubopt(char**, char**, char**) @nogc nothrow;
    int rpmatch(const(char)*) @nogc nothrow;
    c_ulong wcstombs(char*, const(int)*, c_ulong) @nogc nothrow;
    c_ulong mbstowcs(int*, const(char)*, c_ulong) @nogc nothrow;
    int wctomb(char*, int) @nogc nothrow;
    int mbtowc(int*, const(char)*, c_ulong) @nogc nothrow;
    int mblen(const(char)*, c_ulong) @nogc nothrow;
    int qfcvt_r(real, int, int*, int*, char*, c_ulong) @nogc nothrow;
    int qecvt_r(real, int, int*, int*, char*, c_ulong) @nogc nothrow;
    int fcvt_r(double, int, int*, int*, char*, c_ulong) @nogc nothrow;
    int ecvt_r(double, int, int*, int*, char*, c_ulong) @nogc nothrow;
    char* qgcvt(real, int, char*) @nogc nothrow;
    char* qfcvt(real, int, int*, int*) @nogc nothrow;
    char* qecvt(real, int, int*, int*) @nogc nothrow;
    char* gcvt(double, int, char*) @nogc nothrow;
    struct div_t
    {
        int quot;
        int rem;
    }
    struct ldiv_t
    {
        c_long quot;
        c_long rem;
    }
    struct lldiv_t
    {
        long quot;
        long rem;
    }
    char* fcvt(double, int, int*, int*) @nogc nothrow;
    c_ulong __ctype_get_mb_cur_max() @nogc nothrow;
    double atof(const(char)*) @nogc nothrow;
    int atoi(const(char)*) @nogc nothrow;
    c_long atol(const(char)*) @nogc nothrow;
    long atoll(const(char)*) @nogc nothrow;
    double strtod(const(char)*, char**) @nogc nothrow;
    float strtof(const(char)*, char**) @nogc nothrow;
    real strtold(const(char)*, char**) @nogc nothrow;
    c_long strtol(const(char)*, char**, int) @nogc nothrow;
    c_ulong strtoul(const(char)*, char**, int) @nogc nothrow;
    long strtoq(const(char)*, char**, int) @nogc nothrow;
    ulong strtouq(const(char)*, char**, int) @nogc nothrow;
    long strtoll(const(char)*, char**, int) @nogc nothrow;
    ulong strtoull(const(char)*, char**, int) @nogc nothrow;
    char* l64a(c_long) @nogc nothrow;
    c_long a64l(const(char)*) @nogc nothrow;
    c_long random() @nogc nothrow;
    void srandom(uint) @nogc nothrow;
    char* initstate(uint, char*, c_ulong) @nogc nothrow;
    char* setstate(char*) @nogc nothrow;
    struct random_data
    {
        int* fptr;
        int* rptr;
        int* state;
        int rand_type;
        int rand_deg;
        int rand_sep;
        int* end_ptr;
    }
    int random_r(random_data*, int*) @nogc nothrow;
    int srandom_r(uint, random_data*) @nogc nothrow;
    int initstate_r(uint, char*, c_ulong, random_data*) @nogc nothrow;
    int setstate_r(char*, random_data*) @nogc nothrow;
    int rand() @nogc nothrow;
    void srand(uint) @nogc nothrow;
    int rand_r(uint*) @nogc nothrow;
    double drand48() @nogc nothrow;
    double erand48(ushort*) @nogc nothrow;
    c_long lrand48() @nogc nothrow;
    c_long nrand48(ushort*) @nogc nothrow;
    c_long mrand48() @nogc nothrow;
    c_long jrand48(ushort*) @nogc nothrow;
    void srand48(c_long) @nogc nothrow;
    ushort* seed48(ushort*) @nogc nothrow;
    void lcong48(ushort*) @nogc nothrow;
    struct drand48_data
    {
        ushort[3] __x;
        ushort[3] __old_x;
        ushort __c;
        ushort __init;
        ulong __a;
    }
    int drand48_r(drand48_data*, double*) @nogc nothrow;
    int erand48_r(ushort*, drand48_data*, double*) @nogc nothrow;
    int lrand48_r(drand48_data*, c_long*) @nogc nothrow;
    int nrand48_r(ushort*, drand48_data*, c_long*) @nogc nothrow;
    int mrand48_r(drand48_data*, c_long*) @nogc nothrow;
    int jrand48_r(ushort*, drand48_data*, c_long*) @nogc nothrow;
    int srand48_r(c_long, drand48_data*) @nogc nothrow;
    int seed48_r(ushort*, drand48_data*) @nogc nothrow;
    int lcong48_r(ushort*, drand48_data*) @nogc nothrow;
    void* malloc(c_ulong) @nogc nothrow;
    void* calloc(c_ulong, c_ulong) @nogc nothrow;
    void* realloc(void*, c_ulong) @nogc nothrow;
    void free(void*) @nogc nothrow;
    void* valloc(c_ulong) @nogc nothrow;
    int posix_memalign(void**, c_ulong, c_ulong) @nogc nothrow;
    void* aligned_alloc(c_ulong, c_ulong) @nogc nothrow;
    void abort() @nogc nothrow;
    int atexit(void function()) @nogc nothrow;
    int at_quick_exit(void function()) @nogc nothrow;
    int on_exit(void function(int, void*), void*) @nogc nothrow;
    void exit(int) @nogc nothrow;
    void quick_exit(int) @nogc nothrow;
    void _Exit(int) @nogc nothrow;
    char* getenv(const(char)*) @nogc nothrow;
    int putenv(char*) @nogc nothrow;
    int setenv(const(char)*, const(char)*, int) @nogc nothrow;
    int unsetenv(const(char)*) @nogc nothrow;
    int clearenv() @nogc nothrow;
    char* mktemp(char*) @nogc nothrow;
    int mkstemp(char*) @nogc nothrow;
    int mkstemps(char*, int) @nogc nothrow;
    char* mkdtemp(char*) @nogc nothrow;
    int system(const(char)*) @nogc nothrow;
    char* realpath(const(char)*, char*) @nogc nothrow;
    char* ecvt(double, int, int*, int*) @nogc nothrow;
    alias __compar_fn_t = int function(const(void)*, const(void)*);
    void* bsearch(const(void)*, const(void)*, c_ulong, c_ulong, int function(const(void)*, const(void)*)) @nogc nothrow;
    void qsort(void*, c_ulong, c_ulong, int function(const(void)*, const(void)*)) @nogc nothrow;
    int abs(int) @nogc nothrow;
    c_long labs(c_long) @nogc nothrow;
    long llabs(long) @nogc nothrow;
    div_t div(int, int) @nogc nothrow;
    ldiv_t ldiv(c_long, c_long) @nogc nothrow;
    lldiv_t lldiv(long, long) @nogc nothrow;





    static if(!is(typeof(MB_CUR_MAX))) {
        private enum enumMixinStr_MB_CUR_MAX = `enum MB_CUR_MAX = ( __ctype_get_mb_cur_max ( ) );`;
        static if(is(typeof({ mixin(enumMixinStr_MB_CUR_MAX); }))) {
            mixin(enumMixinStr_MB_CUR_MAX);
        }
    }




    static if(!is(typeof(EXIT_SUCCESS))) {
        private enum enumMixinStr_EXIT_SUCCESS = `enum EXIT_SUCCESS = 0;`;
        static if(is(typeof({ mixin(enumMixinStr_EXIT_SUCCESS); }))) {
            mixin(enumMixinStr_EXIT_SUCCESS);
        }
    }




    static if(!is(typeof(EXIT_FAILURE))) {
        private enum enumMixinStr_EXIT_FAILURE = `enum EXIT_FAILURE = 1;`;
        static if(is(typeof({ mixin(enumMixinStr_EXIT_FAILURE); }))) {
            mixin(enumMixinStr_EXIT_FAILURE);
        }
    }




    static if(!is(typeof(RAND_MAX))) {
        private enum enumMixinStr_RAND_MAX = `enum RAND_MAX = 2147483647;`;
        static if(is(typeof({ mixin(enumMixinStr_RAND_MAX); }))) {
            mixin(enumMixinStr_RAND_MAX);
        }
    }




    static if(!is(typeof(__lldiv_t_defined))) {
        private enum enumMixinStr___lldiv_t_defined = `enum __lldiv_t_defined = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___lldiv_t_defined); }))) {
            mixin(enumMixinStr___lldiv_t_defined);
        }
    }




    static if(!is(typeof(__ldiv_t_defined))) {
        private enum enumMixinStr___ldiv_t_defined = `enum __ldiv_t_defined = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___ldiv_t_defined); }))) {
            mixin(enumMixinStr___ldiv_t_defined);
        }
    }
    static if(!is(typeof(_STDLIB_H))) {
        private enum enumMixinStr__STDLIB_H = `enum _STDLIB_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__STDLIB_H); }))) {
            mixin(enumMixinStr__STDLIB_H);
        }
    }
    static if(!is(typeof(WINT_MAX))) {
        private enum enumMixinStr_WINT_MAX = `enum WINT_MAX = ( 4294967295u );`;
        static if(is(typeof({ mixin(enumMixinStr_WINT_MAX); }))) {
            mixin(enumMixinStr_WINT_MAX);
        }
    }




    static if(!is(typeof(WINT_MIN))) {
        private enum enumMixinStr_WINT_MIN = `enum WINT_MIN = ( 0u );`;
        static if(is(typeof({ mixin(enumMixinStr_WINT_MIN); }))) {
            mixin(enumMixinStr_WINT_MIN);
        }
    }




    static if(!is(typeof(WCHAR_MAX))) {
        private enum enumMixinStr_WCHAR_MAX = `enum WCHAR_MAX = __WCHAR_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr_WCHAR_MAX); }))) {
            mixin(enumMixinStr_WCHAR_MAX);
        }
    }




    static if(!is(typeof(WCHAR_MIN))) {
        private enum enumMixinStr_WCHAR_MIN = `enum WCHAR_MIN = __WCHAR_MIN;`;
        static if(is(typeof({ mixin(enumMixinStr_WCHAR_MIN); }))) {
            mixin(enumMixinStr_WCHAR_MIN);
        }
    }




    static if(!is(typeof(SIZE_MAX))) {
        private enum enumMixinStr_SIZE_MAX = `enum SIZE_MAX = ( 18446744073709551615UL );`;
        static if(is(typeof({ mixin(enumMixinStr_SIZE_MAX); }))) {
            mixin(enumMixinStr_SIZE_MAX);
        }
    }




    static if(!is(typeof(SIG_ATOMIC_MAX))) {
        private enum enumMixinStr_SIG_ATOMIC_MAX = `enum SIG_ATOMIC_MAX = ( 2147483647 );`;
        static if(is(typeof({ mixin(enumMixinStr_SIG_ATOMIC_MAX); }))) {
            mixin(enumMixinStr_SIG_ATOMIC_MAX);
        }
    }




    static if(!is(typeof(SIG_ATOMIC_MIN))) {
        private enum enumMixinStr_SIG_ATOMIC_MIN = `enum SIG_ATOMIC_MIN = ( - 2147483647 - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_SIG_ATOMIC_MIN); }))) {
            mixin(enumMixinStr_SIG_ATOMIC_MIN);
        }
    }




    static if(!is(typeof(PTRDIFF_MAX))) {
        private enum enumMixinStr_PTRDIFF_MAX = `enum PTRDIFF_MAX = ( 9223372036854775807L );`;
        static if(is(typeof({ mixin(enumMixinStr_PTRDIFF_MAX); }))) {
            mixin(enumMixinStr_PTRDIFF_MAX);
        }
    }




    static if(!is(typeof(PTRDIFF_MIN))) {
        private enum enumMixinStr_PTRDIFF_MIN = `enum PTRDIFF_MIN = ( - 9223372036854775807L - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_PTRDIFF_MIN); }))) {
            mixin(enumMixinStr_PTRDIFF_MIN);
        }
    }




    static if(!is(typeof(UINTMAX_MAX))) {
        private enum enumMixinStr_UINTMAX_MAX = `enum UINTMAX_MAX = ( 18446744073709551615UL );`;
        static if(is(typeof({ mixin(enumMixinStr_UINTMAX_MAX); }))) {
            mixin(enumMixinStr_UINTMAX_MAX);
        }
    }




    static if(!is(typeof(INTMAX_MAX))) {
        private enum enumMixinStr_INTMAX_MAX = `enum INTMAX_MAX = ( 9223372036854775807L );`;
        static if(is(typeof({ mixin(enumMixinStr_INTMAX_MAX); }))) {
            mixin(enumMixinStr_INTMAX_MAX);
        }
    }




    static if(!is(typeof(INTMAX_MIN))) {
        private enum enumMixinStr_INTMAX_MIN = `enum INTMAX_MIN = ( - 9223372036854775807L - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INTMAX_MIN); }))) {
            mixin(enumMixinStr_INTMAX_MIN);
        }
    }




    static if(!is(typeof(UINTPTR_MAX))) {
        private enum enumMixinStr_UINTPTR_MAX = `enum UINTPTR_MAX = ( 18446744073709551615UL );`;
        static if(is(typeof({ mixin(enumMixinStr_UINTPTR_MAX); }))) {
            mixin(enumMixinStr_UINTPTR_MAX);
        }
    }




    static if(!is(typeof(INTPTR_MAX))) {
        private enum enumMixinStr_INTPTR_MAX = `enum INTPTR_MAX = ( 9223372036854775807L );`;
        static if(is(typeof({ mixin(enumMixinStr_INTPTR_MAX); }))) {
            mixin(enumMixinStr_INTPTR_MAX);
        }
    }




    static if(!is(typeof(INTPTR_MIN))) {
        private enum enumMixinStr_INTPTR_MIN = `enum INTPTR_MIN = ( - 9223372036854775807L - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INTPTR_MIN); }))) {
            mixin(enumMixinStr_INTPTR_MIN);
        }
    }




    static if(!is(typeof(UINT_FAST64_MAX))) {
        private enum enumMixinStr_UINT_FAST64_MAX = `enum UINT_FAST64_MAX = ( 18446744073709551615UL );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT_FAST64_MAX); }))) {
            mixin(enumMixinStr_UINT_FAST64_MAX);
        }
    }




    static if(!is(typeof(UINT_FAST32_MAX))) {
        private enum enumMixinStr_UINT_FAST32_MAX = `enum UINT_FAST32_MAX = ( 18446744073709551615UL );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT_FAST32_MAX); }))) {
            mixin(enumMixinStr_UINT_FAST32_MAX);
        }
    }




    static if(!is(typeof(UINT_FAST16_MAX))) {
        private enum enumMixinStr_UINT_FAST16_MAX = `enum UINT_FAST16_MAX = ( 18446744073709551615UL );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT_FAST16_MAX); }))) {
            mixin(enumMixinStr_UINT_FAST16_MAX);
        }
    }




    static if(!is(typeof(UINT_FAST8_MAX))) {
        private enum enumMixinStr_UINT_FAST8_MAX = `enum UINT_FAST8_MAX = ( 255 );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT_FAST8_MAX); }))) {
            mixin(enumMixinStr_UINT_FAST8_MAX);
        }
    }




    static if(!is(typeof(INT_FAST64_MAX))) {
        private enum enumMixinStr_INT_FAST64_MAX = `enum INT_FAST64_MAX = ( 9223372036854775807L );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_FAST64_MAX); }))) {
            mixin(enumMixinStr_INT_FAST64_MAX);
        }
    }




    static if(!is(typeof(INT_FAST32_MAX))) {
        private enum enumMixinStr_INT_FAST32_MAX = `enum INT_FAST32_MAX = ( 9223372036854775807L );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_FAST32_MAX); }))) {
            mixin(enumMixinStr_INT_FAST32_MAX);
        }
    }




    static if(!is(typeof(INT_FAST16_MAX))) {
        private enum enumMixinStr_INT_FAST16_MAX = `enum INT_FAST16_MAX = ( 9223372036854775807L );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_FAST16_MAX); }))) {
            mixin(enumMixinStr_INT_FAST16_MAX);
        }
    }




    static if(!is(typeof(INT_FAST8_MAX))) {
        private enum enumMixinStr_INT_FAST8_MAX = `enum INT_FAST8_MAX = ( 127 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_FAST8_MAX); }))) {
            mixin(enumMixinStr_INT_FAST8_MAX);
        }
    }




    static if(!is(typeof(INT_FAST64_MIN))) {
        private enum enumMixinStr_INT_FAST64_MIN = `enum INT_FAST64_MIN = ( - 9223372036854775807L - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_FAST64_MIN); }))) {
            mixin(enumMixinStr_INT_FAST64_MIN);
        }
    }




    static if(!is(typeof(INT_FAST32_MIN))) {
        private enum enumMixinStr_INT_FAST32_MIN = `enum INT_FAST32_MIN = ( - 9223372036854775807L - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_FAST32_MIN); }))) {
            mixin(enumMixinStr_INT_FAST32_MIN);
        }
    }




    static if(!is(typeof(INT_FAST16_MIN))) {
        private enum enumMixinStr_INT_FAST16_MIN = `enum INT_FAST16_MIN = ( - 9223372036854775807L - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_FAST16_MIN); }))) {
            mixin(enumMixinStr_INT_FAST16_MIN);
        }
    }




    static if(!is(typeof(INT_FAST8_MIN))) {
        private enum enumMixinStr_INT_FAST8_MIN = `enum INT_FAST8_MIN = ( - 128 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_FAST8_MIN); }))) {
            mixin(enumMixinStr_INT_FAST8_MIN);
        }
    }




    static if(!is(typeof(UINT_LEAST64_MAX))) {
        private enum enumMixinStr_UINT_LEAST64_MAX = `enum UINT_LEAST64_MAX = ( 18446744073709551615UL );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT_LEAST64_MAX); }))) {
            mixin(enumMixinStr_UINT_LEAST64_MAX);
        }
    }




    static if(!is(typeof(UINT_LEAST32_MAX))) {
        private enum enumMixinStr_UINT_LEAST32_MAX = `enum UINT_LEAST32_MAX = ( 4294967295U );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT_LEAST32_MAX); }))) {
            mixin(enumMixinStr_UINT_LEAST32_MAX);
        }
    }




    static if(!is(typeof(UINT_LEAST16_MAX))) {
        private enum enumMixinStr_UINT_LEAST16_MAX = `enum UINT_LEAST16_MAX = ( 65535 );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT_LEAST16_MAX); }))) {
            mixin(enumMixinStr_UINT_LEAST16_MAX);
        }
    }




    static if(!is(typeof(UINT_LEAST8_MAX))) {
        private enum enumMixinStr_UINT_LEAST8_MAX = `enum UINT_LEAST8_MAX = ( 255 );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT_LEAST8_MAX); }))) {
            mixin(enumMixinStr_UINT_LEAST8_MAX);
        }
    }




    static if(!is(typeof(INT_LEAST64_MAX))) {
        private enum enumMixinStr_INT_LEAST64_MAX = `enum INT_LEAST64_MAX = ( 9223372036854775807L );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_LEAST64_MAX); }))) {
            mixin(enumMixinStr_INT_LEAST64_MAX);
        }
    }




    static if(!is(typeof(INT_LEAST32_MAX))) {
        private enum enumMixinStr_INT_LEAST32_MAX = `enum INT_LEAST32_MAX = ( 2147483647 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_LEAST32_MAX); }))) {
            mixin(enumMixinStr_INT_LEAST32_MAX);
        }
    }




    static if(!is(typeof(INT_LEAST16_MAX))) {
        private enum enumMixinStr_INT_LEAST16_MAX = `enum INT_LEAST16_MAX = ( 32767 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_LEAST16_MAX); }))) {
            mixin(enumMixinStr_INT_LEAST16_MAX);
        }
    }




    static if(!is(typeof(INT_LEAST8_MAX))) {
        private enum enumMixinStr_INT_LEAST8_MAX = `enum INT_LEAST8_MAX = ( 127 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_LEAST8_MAX); }))) {
            mixin(enumMixinStr_INT_LEAST8_MAX);
        }
    }




    static if(!is(typeof(INT_LEAST64_MIN))) {
        private enum enumMixinStr_INT_LEAST64_MIN = `enum INT_LEAST64_MIN = ( - 9223372036854775807L - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_LEAST64_MIN); }))) {
            mixin(enumMixinStr_INT_LEAST64_MIN);
        }
    }




    static if(!is(typeof(INT_LEAST32_MIN))) {
        private enum enumMixinStr_INT_LEAST32_MIN = `enum INT_LEAST32_MIN = ( - 2147483647 - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_LEAST32_MIN); }))) {
            mixin(enumMixinStr_INT_LEAST32_MIN);
        }
    }




    static if(!is(typeof(INT_LEAST16_MIN))) {
        private enum enumMixinStr_INT_LEAST16_MIN = `enum INT_LEAST16_MIN = ( - 32767 - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_LEAST16_MIN); }))) {
            mixin(enumMixinStr_INT_LEAST16_MIN);
        }
    }




    static if(!is(typeof(INT_LEAST8_MIN))) {
        private enum enumMixinStr_INT_LEAST8_MIN = `enum INT_LEAST8_MIN = ( - 128 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_LEAST8_MIN); }))) {
            mixin(enumMixinStr_INT_LEAST8_MIN);
        }
    }




    static if(!is(typeof(UINT64_MAX))) {
        private enum enumMixinStr_UINT64_MAX = `enum UINT64_MAX = ( 18446744073709551615UL );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT64_MAX); }))) {
            mixin(enumMixinStr_UINT64_MAX);
        }
    }






    static if(!is(typeof(UINT32_MAX))) {
        private enum enumMixinStr_UINT32_MAX = `enum UINT32_MAX = ( 4294967295U );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT32_MAX); }))) {
            mixin(enumMixinStr_UINT32_MAX);
        }
    }




    static if(!is(typeof(_BITS_BYTESWAP_H))) {
        private enum enumMixinStr__BITS_BYTESWAP_H = `enum _BITS_BYTESWAP_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__BITS_BYTESWAP_H); }))) {
            mixin(enumMixinStr__BITS_BYTESWAP_H);
        }
    }




    static if(!is(typeof(UINT16_MAX))) {
        private enum enumMixinStr_UINT16_MAX = `enum UINT16_MAX = ( 65535 );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT16_MAX); }))) {
            mixin(enumMixinStr_UINT16_MAX);
        }
    }




    static if(!is(typeof(UINT8_MAX))) {
        private enum enumMixinStr_UINT8_MAX = `enum UINT8_MAX = ( 255 );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT8_MAX); }))) {
            mixin(enumMixinStr_UINT8_MAX);
        }
    }




    static if(!is(typeof(INT64_MAX))) {
        private enum enumMixinStr_INT64_MAX = `enum INT64_MAX = ( 9223372036854775807L );`;
        static if(is(typeof({ mixin(enumMixinStr_INT64_MAX); }))) {
            mixin(enumMixinStr_INT64_MAX);
        }
    }






    static if(!is(typeof(INT32_MAX))) {
        private enum enumMixinStr_INT32_MAX = `enum INT32_MAX = ( 2147483647 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT32_MAX); }))) {
            mixin(enumMixinStr_INT32_MAX);
        }
    }






    static if(!is(typeof(INT16_MAX))) {
        private enum enumMixinStr_INT16_MAX = `enum INT16_MAX = ( 32767 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT16_MAX); }))) {
            mixin(enumMixinStr_INT16_MAX);
        }
    }




    static if(!is(typeof(INT8_MAX))) {
        private enum enumMixinStr_INT8_MAX = `enum INT8_MAX = ( 127 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT8_MAX); }))) {
            mixin(enumMixinStr_INT8_MAX);
        }
    }




    static if(!is(typeof(INT64_MIN))) {
        private enum enumMixinStr_INT64_MIN = `enum INT64_MIN = ( - 9223372036854775807L - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT64_MIN); }))) {
            mixin(enumMixinStr_INT64_MIN);
        }
    }




    static if(!is(typeof(INT32_MIN))) {
        private enum enumMixinStr_INT32_MIN = `enum INT32_MIN = ( - 2147483647 - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT32_MIN); }))) {
            mixin(enumMixinStr_INT32_MIN);
        }
    }




    static if(!is(typeof(INT16_MIN))) {
        private enum enumMixinStr_INT16_MIN = `enum INT16_MIN = ( - 32767 - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT16_MIN); }))) {
            mixin(enumMixinStr_INT16_MIN);
        }
    }






    static if(!is(typeof(INT8_MIN))) {
        private enum enumMixinStr_INT8_MIN = `enum INT8_MIN = ( - 128 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT8_MIN); }))) {
            mixin(enumMixinStr_INT8_MIN);
        }
    }
    static if(!is(typeof(__BYTE_ORDER))) {
        private enum enumMixinStr___BYTE_ORDER = `enum __BYTE_ORDER = __LITTLE_ENDIAN;`;
        static if(is(typeof({ mixin(enumMixinStr___BYTE_ORDER); }))) {
            mixin(enumMixinStr___BYTE_ORDER);
        }
    }






    static if(!is(typeof(_STDINT_H))) {
        private enum enumMixinStr__STDINT_H = `enum _STDINT_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__STDINT_H); }))) {
            mixin(enumMixinStr__STDINT_H);
        }
    }




    static if(!is(typeof(__HAVE_FLOAT16))) {
        private enum enumMixinStr___HAVE_FLOAT16 = `enum __HAVE_FLOAT16 = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___HAVE_FLOAT16); }))) {
            mixin(enumMixinStr___HAVE_FLOAT16);
        }
    }




    static if(!is(typeof(__HAVE_FLOAT32))) {
        private enum enumMixinStr___HAVE_FLOAT32 = `enum __HAVE_FLOAT32 = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___HAVE_FLOAT32); }))) {
            mixin(enumMixinStr___HAVE_FLOAT32);
        }
    }




    static if(!is(typeof(__HAVE_FLOAT64))) {
        private enum enumMixinStr___HAVE_FLOAT64 = `enum __HAVE_FLOAT64 = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___HAVE_FLOAT64); }))) {
            mixin(enumMixinStr___HAVE_FLOAT64);
        }
    }




    static if(!is(typeof(__HAVE_FLOAT32X))) {
        private enum enumMixinStr___HAVE_FLOAT32X = `enum __HAVE_FLOAT32X = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___HAVE_FLOAT32X); }))) {
            mixin(enumMixinStr___HAVE_FLOAT32X);
        }
    }




    static if(!is(typeof(__HAVE_FLOAT128X))) {
        private enum enumMixinStr___HAVE_FLOAT128X = `enum __HAVE_FLOAT128X = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___HAVE_FLOAT128X); }))) {
            mixin(enumMixinStr___HAVE_FLOAT128X);
        }
    }




    static if(!is(typeof(__HAVE_DISTINCT_FLOAT16))) {
        private enum enumMixinStr___HAVE_DISTINCT_FLOAT16 = `enum __HAVE_DISTINCT_FLOAT16 = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___HAVE_DISTINCT_FLOAT16); }))) {
            mixin(enumMixinStr___HAVE_DISTINCT_FLOAT16);
        }
    }




    static if(!is(typeof(__HAVE_DISTINCT_FLOAT32))) {
        private enum enumMixinStr___HAVE_DISTINCT_FLOAT32 = `enum __HAVE_DISTINCT_FLOAT32 = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___HAVE_DISTINCT_FLOAT32); }))) {
            mixin(enumMixinStr___HAVE_DISTINCT_FLOAT32);
        }
    }




    static if(!is(typeof(__HAVE_DISTINCT_FLOAT64))) {
        private enum enumMixinStr___HAVE_DISTINCT_FLOAT64 = `enum __HAVE_DISTINCT_FLOAT64 = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___HAVE_DISTINCT_FLOAT64); }))) {
            mixin(enumMixinStr___HAVE_DISTINCT_FLOAT64);
        }
    }




    static if(!is(typeof(__HAVE_DISTINCT_FLOAT32X))) {
        private enum enumMixinStr___HAVE_DISTINCT_FLOAT32X = `enum __HAVE_DISTINCT_FLOAT32X = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___HAVE_DISTINCT_FLOAT32X); }))) {
            mixin(enumMixinStr___HAVE_DISTINCT_FLOAT32X);
        }
    }




    static if(!is(typeof(__HAVE_DISTINCT_FLOAT64X))) {
        private enum enumMixinStr___HAVE_DISTINCT_FLOAT64X = `enum __HAVE_DISTINCT_FLOAT64X = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___HAVE_DISTINCT_FLOAT64X); }))) {
            mixin(enumMixinStr___HAVE_DISTINCT_FLOAT64X);
        }
    }




    static if(!is(typeof(__HAVE_DISTINCT_FLOAT128X))) {
        private enum enumMixinStr___HAVE_DISTINCT_FLOAT128X = `enum __HAVE_DISTINCT_FLOAT128X = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___HAVE_DISTINCT_FLOAT128X); }))) {
            mixin(enumMixinStr___HAVE_DISTINCT_FLOAT128X);
        }
    }




    static if(!is(typeof(__HAVE_FLOATN_NOT_TYPEDEF))) {
        private enum enumMixinStr___HAVE_FLOATN_NOT_TYPEDEF = `enum __HAVE_FLOATN_NOT_TYPEDEF = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___HAVE_FLOATN_NOT_TYPEDEF); }))) {
            mixin(enumMixinStr___HAVE_FLOATN_NOT_TYPEDEF);
        }
    }






    static if(!is(typeof(_STDC_PREDEF_H))) {
        private enum enumMixinStr__STDC_PREDEF_H = `enum _STDC_PREDEF_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__STDC_PREDEF_H); }))) {
            mixin(enumMixinStr__STDC_PREDEF_H);
        }
    }
    static if(!is(typeof(__GLIBC_MINOR__))) {
        private enum enumMixinStr___GLIBC_MINOR__ = `enum __GLIBC_MINOR__ = 27;`;
        static if(is(typeof({ mixin(enumMixinStr___GLIBC_MINOR__); }))) {
            mixin(enumMixinStr___GLIBC_MINOR__);
        }
    }




    static if(!is(typeof(__GLIBC__))) {
        private enum enumMixinStr___GLIBC__ = `enum __GLIBC__ = 2;`;
        static if(is(typeof({ mixin(enumMixinStr___GLIBC__); }))) {
            mixin(enumMixinStr___GLIBC__);
        }
    }






    static if(!is(typeof(__GNU_LIBRARY__))) {
        private enum enumMixinStr___GNU_LIBRARY__ = `enum __GNU_LIBRARY__ = 6;`;
        static if(is(typeof({ mixin(enumMixinStr___GNU_LIBRARY__); }))) {
            mixin(enumMixinStr___GNU_LIBRARY__);
        }
    }




    static if(!is(typeof(__GLIBC_USE_DEPRECATED_GETS))) {
        private enum enumMixinStr___GLIBC_USE_DEPRECATED_GETS = `enum __GLIBC_USE_DEPRECATED_GETS = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___GLIBC_USE_DEPRECATED_GETS); }))) {
            mixin(enumMixinStr___GLIBC_USE_DEPRECATED_GETS);
        }
    }




    static if(!is(typeof(__USE_FORTIFY_LEVEL))) {
        private enum enumMixinStr___USE_FORTIFY_LEVEL = `enum __USE_FORTIFY_LEVEL = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___USE_FORTIFY_LEVEL); }))) {
            mixin(enumMixinStr___USE_FORTIFY_LEVEL);
        }
    }






    static if(!is(typeof(__USE_ATFILE))) {
        private enum enumMixinStr___USE_ATFILE = `enum __USE_ATFILE = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___USE_ATFILE); }))) {
            mixin(enumMixinStr___USE_ATFILE);
        }
    }




    static if(!is(typeof(__USE_MISC))) {
        private enum enumMixinStr___USE_MISC = `enum __USE_MISC = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___USE_MISC); }))) {
            mixin(enumMixinStr___USE_MISC);
        }
    }




    static if(!is(typeof(_ATFILE_SOURCE))) {
        private enum enumMixinStr__ATFILE_SOURCE = `enum _ATFILE_SOURCE = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__ATFILE_SOURCE); }))) {
            mixin(enumMixinStr__ATFILE_SOURCE);
        }
    }




    static if(!is(typeof(__USE_XOPEN2K8))) {
        private enum enumMixinStr___USE_XOPEN2K8 = `enum __USE_XOPEN2K8 = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___USE_XOPEN2K8); }))) {
            mixin(enumMixinStr___USE_XOPEN2K8);
        }
    }




    static if(!is(typeof(__CFLOAT32))) {
        private enum enumMixinStr___CFLOAT32 = `enum __CFLOAT32 = _Complex float;`;
        static if(is(typeof({ mixin(enumMixinStr___CFLOAT32); }))) {
            mixin(enumMixinStr___CFLOAT32);
        }
    }




    static if(!is(typeof(__USE_ISOC99))) {
        private enum enumMixinStr___USE_ISOC99 = `enum __USE_ISOC99 = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___USE_ISOC99); }))) {
            mixin(enumMixinStr___USE_ISOC99);
        }
    }




    static if(!is(typeof(__USE_ISOC95))) {
        private enum enumMixinStr___USE_ISOC95 = `enum __USE_ISOC95 = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___USE_ISOC95); }))) {
            mixin(enumMixinStr___USE_ISOC95);
        }
    }




    static if(!is(typeof(__CFLOAT64))) {
        private enum enumMixinStr___CFLOAT64 = `enum __CFLOAT64 = _Complex double;`;
        static if(is(typeof({ mixin(enumMixinStr___CFLOAT64); }))) {
            mixin(enumMixinStr___CFLOAT64);
        }
    }




    static if(!is(typeof(__USE_XOPEN2K))) {
        private enum enumMixinStr___USE_XOPEN2K = `enum __USE_XOPEN2K = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___USE_XOPEN2K); }))) {
            mixin(enumMixinStr___USE_XOPEN2K);
        }
    }




    static if(!is(typeof(__USE_POSIX199506))) {
        private enum enumMixinStr___USE_POSIX199506 = `enum __USE_POSIX199506 = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___USE_POSIX199506); }))) {
            mixin(enumMixinStr___USE_POSIX199506);
        }
    }




    static if(!is(typeof(__CFLOAT32X))) {
        private enum enumMixinStr___CFLOAT32X = `enum __CFLOAT32X = _Complex double;`;
        static if(is(typeof({ mixin(enumMixinStr___CFLOAT32X); }))) {
            mixin(enumMixinStr___CFLOAT32X);
        }
    }




    static if(!is(typeof(__USE_POSIX199309))) {
        private enum enumMixinStr___USE_POSIX199309 = `enum __USE_POSIX199309 = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___USE_POSIX199309); }))) {
            mixin(enumMixinStr___USE_POSIX199309);
        }
    }




    static if(!is(typeof(__USE_POSIX2))) {
        private enum enumMixinStr___USE_POSIX2 = `enum __USE_POSIX2 = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___USE_POSIX2); }))) {
            mixin(enumMixinStr___USE_POSIX2);
        }
    }




    static if(!is(typeof(__USE_POSIX))) {
        private enum enumMixinStr___USE_POSIX = `enum __USE_POSIX = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___USE_POSIX); }))) {
            mixin(enumMixinStr___USE_POSIX);
        }
    }




    static if(!is(typeof(__CFLOAT64X))) {
        private enum enumMixinStr___CFLOAT64X = `enum __CFLOAT64X = _Complex long double;`;
        static if(is(typeof({ mixin(enumMixinStr___CFLOAT64X); }))) {
            mixin(enumMixinStr___CFLOAT64X);
        }
    }




    static if(!is(typeof(_POSIX_C_SOURCE))) {
        private enum enumMixinStr__POSIX_C_SOURCE = `enum _POSIX_C_SOURCE = 200809L;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_C_SOURCE); }))) {
            mixin(enumMixinStr__POSIX_C_SOURCE);
        }
    }




    static if(!is(typeof(_POSIX_SOURCE))) {
        private enum enumMixinStr__POSIX_SOURCE = `enum _POSIX_SOURCE = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_SOURCE); }))) {
            mixin(enumMixinStr__POSIX_SOURCE);
        }
    }




    static if(!is(typeof(__USE_POSIX_IMPLICITLY))) {
        private enum enumMixinStr___USE_POSIX_IMPLICITLY = `enum __USE_POSIX_IMPLICITLY = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___USE_POSIX_IMPLICITLY); }))) {
            mixin(enumMixinStr___USE_POSIX_IMPLICITLY);
        }
    }




    static if(!is(typeof(__USE_ISOC11))) {
        private enum enumMixinStr___USE_ISOC11 = `enum __USE_ISOC11 = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___USE_ISOC11); }))) {
            mixin(enumMixinStr___USE_ISOC11);
        }
    }
    static if(!is(typeof(_DEFAULT_SOURCE))) {
        private enum enumMixinStr__DEFAULT_SOURCE = `enum _DEFAULT_SOURCE = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__DEFAULT_SOURCE); }))) {
            mixin(enumMixinStr__DEFAULT_SOURCE);
        }
    }
    static if(!is(typeof(_FEATURES_H))) {
        private enum enumMixinStr__FEATURES_H = `enum _FEATURES_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__FEATURES_H); }))) {
            mixin(enumMixinStr__FEATURES_H);
        }
    }
    static if(!is(typeof(__HAVE_FLOAT128))) {
        private enum enumMixinStr___HAVE_FLOAT128 = `enum __HAVE_FLOAT128 = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___HAVE_FLOAT128); }))) {
            mixin(enumMixinStr___HAVE_FLOAT128);
        }
    }




    static if(!is(typeof(BYTE_ORDER))) {
        private enum enumMixinStr_BYTE_ORDER = `enum BYTE_ORDER = __LITTLE_ENDIAN;`;
        static if(is(typeof({ mixin(enumMixinStr_BYTE_ORDER); }))) {
            mixin(enumMixinStr_BYTE_ORDER);
        }
    }




    static if(!is(typeof(__HAVE_DISTINCT_FLOAT128))) {
        private enum enumMixinStr___HAVE_DISTINCT_FLOAT128 = `enum __HAVE_DISTINCT_FLOAT128 = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___HAVE_DISTINCT_FLOAT128); }))) {
            mixin(enumMixinStr___HAVE_DISTINCT_FLOAT128);
        }
    }




    static if(!is(typeof(__HAVE_FLOAT64X))) {
        private enum enumMixinStr___HAVE_FLOAT64X = `enum __HAVE_FLOAT64X = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___HAVE_FLOAT64X); }))) {
            mixin(enumMixinStr___HAVE_FLOAT64X);
        }
    }




    static if(!is(typeof(__HAVE_FLOAT64X_LONG_DOUBLE))) {
        private enum enumMixinStr___HAVE_FLOAT64X_LONG_DOUBLE = `enum __HAVE_FLOAT64X_LONG_DOUBLE = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___HAVE_FLOAT64X_LONG_DOUBLE); }))) {
            mixin(enumMixinStr___HAVE_FLOAT64X_LONG_DOUBLE);
        }
    }




    static if(!is(typeof(PDP_ENDIAN))) {
        private enum enumMixinStr_PDP_ENDIAN = `enum PDP_ENDIAN = __PDP_ENDIAN;`;
        static if(is(typeof({ mixin(enumMixinStr_PDP_ENDIAN); }))) {
            mixin(enumMixinStr_PDP_ENDIAN);
        }
    }




    static if(!is(typeof(BIG_ENDIAN))) {
        private enum enumMixinStr_BIG_ENDIAN = `enum BIG_ENDIAN = __BIG_ENDIAN;`;
        static if(is(typeof({ mixin(enumMixinStr_BIG_ENDIAN); }))) {
            mixin(enumMixinStr_BIG_ENDIAN);
        }
    }




    static if(!is(typeof(LITTLE_ENDIAN))) {
        private enum enumMixinStr_LITTLE_ENDIAN = `enum LITTLE_ENDIAN = __LITTLE_ENDIAN;`;
        static if(is(typeof({ mixin(enumMixinStr_LITTLE_ENDIAN); }))) {
            mixin(enumMixinStr_LITTLE_ENDIAN);
        }
    }




    static if(!is(typeof(__FLOAT_WORD_ORDER))) {
        private enum enumMixinStr___FLOAT_WORD_ORDER = `enum __FLOAT_WORD_ORDER = __LITTLE_ENDIAN;`;
        static if(is(typeof({ mixin(enumMixinStr___FLOAT_WORD_ORDER); }))) {
            mixin(enumMixinStr___FLOAT_WORD_ORDER);
        }
    }




    static if(!is(typeof(__PDP_ENDIAN))) {
        private enum enumMixinStr___PDP_ENDIAN = `enum __PDP_ENDIAN = 3412;`;
        static if(is(typeof({ mixin(enumMixinStr___PDP_ENDIAN); }))) {
            mixin(enumMixinStr___PDP_ENDIAN);
        }
    }




    static if(!is(typeof(__BIG_ENDIAN))) {
        private enum enumMixinStr___BIG_ENDIAN = `enum __BIG_ENDIAN = 4321;`;
        static if(is(typeof({ mixin(enumMixinStr___BIG_ENDIAN); }))) {
            mixin(enumMixinStr___BIG_ENDIAN);
        }
    }




    static if(!is(typeof(__LITTLE_ENDIAN))) {
        private enum enumMixinStr___LITTLE_ENDIAN = `enum __LITTLE_ENDIAN = 1234;`;
        static if(is(typeof({ mixin(enumMixinStr___LITTLE_ENDIAN); }))) {
            mixin(enumMixinStr___LITTLE_ENDIAN);
        }
    }




    static if(!is(typeof(_ENDIAN_H))) {
        private enum enumMixinStr__ENDIAN_H = `enum _ENDIAN_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__ENDIAN_H); }))) {
            mixin(enumMixinStr__ENDIAN_H);
        }
    }




    static if(!is(typeof(__GLIBC_USE_LIB_EXT2))) {
        private enum enumMixinStr___GLIBC_USE_LIB_EXT2 = `enum __GLIBC_USE_LIB_EXT2 = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___GLIBC_USE_LIB_EXT2); }))) {
            mixin(enumMixinStr___GLIBC_USE_LIB_EXT2);
        }
    }




    static if(!is(typeof(__GLIBC_USE_IEC_60559_BFP_EXT))) {
        private enum enumMixinStr___GLIBC_USE_IEC_60559_BFP_EXT = `enum __GLIBC_USE_IEC_60559_BFP_EXT = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___GLIBC_USE_IEC_60559_BFP_EXT); }))) {
            mixin(enumMixinStr___GLIBC_USE_IEC_60559_BFP_EXT);
        }
    }




    static if(!is(typeof(__GLIBC_USE_IEC_60559_FUNCS_EXT))) {
        private enum enumMixinStr___GLIBC_USE_IEC_60559_FUNCS_EXT = `enum __GLIBC_USE_IEC_60559_FUNCS_EXT = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___GLIBC_USE_IEC_60559_FUNCS_EXT); }))) {
            mixin(enumMixinStr___GLIBC_USE_IEC_60559_FUNCS_EXT);
        }
    }




    static if(!is(typeof(__GLIBC_USE_IEC_60559_TYPES_EXT))) {
        private enum enumMixinStr___GLIBC_USE_IEC_60559_TYPES_EXT = `enum __GLIBC_USE_IEC_60559_TYPES_EXT = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___GLIBC_USE_IEC_60559_TYPES_EXT); }))) {
            mixin(enumMixinStr___GLIBC_USE_IEC_60559_TYPES_EXT);
        }
    }




    static if(!is(typeof(_BITS_PTHREADTYPES_ARCH_H))) {
        private enum enumMixinStr__BITS_PTHREADTYPES_ARCH_H = `enum _BITS_PTHREADTYPES_ARCH_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__BITS_PTHREADTYPES_ARCH_H); }))) {
            mixin(enumMixinStr__BITS_PTHREADTYPES_ARCH_H);
        }
    }




    static if(!is(typeof(NULL))) {
        private enum enumMixinStr_NULL = `enum NULL = ( cast( void * ) 0 );`;
        static if(is(typeof({ mixin(enumMixinStr_NULL); }))) {
            mixin(enumMixinStr_NULL);
        }
    }
    static if(!is(typeof(__SIZEOF_PTHREAD_MUTEX_T))) {
        private enum enumMixinStr___SIZEOF_PTHREAD_MUTEX_T = `enum __SIZEOF_PTHREAD_MUTEX_T = 40;`;
        static if(is(typeof({ mixin(enumMixinStr___SIZEOF_PTHREAD_MUTEX_T); }))) {
            mixin(enumMixinStr___SIZEOF_PTHREAD_MUTEX_T);
        }
    }




    static if(!is(typeof(__SIZEOF_PTHREAD_ATTR_T))) {
        private enum enumMixinStr___SIZEOF_PTHREAD_ATTR_T = `enum __SIZEOF_PTHREAD_ATTR_T = 56;`;
        static if(is(typeof({ mixin(enumMixinStr___SIZEOF_PTHREAD_ATTR_T); }))) {
            mixin(enumMixinStr___SIZEOF_PTHREAD_ATTR_T);
        }
    }




    static if(!is(typeof(__SIZEOF_PTHREAD_RWLOCK_T))) {
        private enum enumMixinStr___SIZEOF_PTHREAD_RWLOCK_T = `enum __SIZEOF_PTHREAD_RWLOCK_T = 56;`;
        static if(is(typeof({ mixin(enumMixinStr___SIZEOF_PTHREAD_RWLOCK_T); }))) {
            mixin(enumMixinStr___SIZEOF_PTHREAD_RWLOCK_T);
        }
    }




    static if(!is(typeof(__SIZEOF_PTHREAD_BARRIER_T))) {
        private enum enumMixinStr___SIZEOF_PTHREAD_BARRIER_T = `enum __SIZEOF_PTHREAD_BARRIER_T = 32;`;
        static if(is(typeof({ mixin(enumMixinStr___SIZEOF_PTHREAD_BARRIER_T); }))) {
            mixin(enumMixinStr___SIZEOF_PTHREAD_BARRIER_T);
        }
    }




    static if(!is(typeof(__SIZEOF_PTHREAD_MUTEXATTR_T))) {
        private enum enumMixinStr___SIZEOF_PTHREAD_MUTEXATTR_T = `enum __SIZEOF_PTHREAD_MUTEXATTR_T = 4;`;
        static if(is(typeof({ mixin(enumMixinStr___SIZEOF_PTHREAD_MUTEXATTR_T); }))) {
            mixin(enumMixinStr___SIZEOF_PTHREAD_MUTEXATTR_T);
        }
    }




    static if(!is(typeof(__SIZEOF_PTHREAD_COND_T))) {
        private enum enumMixinStr___SIZEOF_PTHREAD_COND_T = `enum __SIZEOF_PTHREAD_COND_T = 48;`;
        static if(is(typeof({ mixin(enumMixinStr___SIZEOF_PTHREAD_COND_T); }))) {
            mixin(enumMixinStr___SIZEOF_PTHREAD_COND_T);
        }
    }




    static if(!is(typeof(__SIZEOF_PTHREAD_CONDATTR_T))) {
        private enum enumMixinStr___SIZEOF_PTHREAD_CONDATTR_T = `enum __SIZEOF_PTHREAD_CONDATTR_T = 4;`;
        static if(is(typeof({ mixin(enumMixinStr___SIZEOF_PTHREAD_CONDATTR_T); }))) {
            mixin(enumMixinStr___SIZEOF_PTHREAD_CONDATTR_T);
        }
    }




    static if(!is(typeof(__SIZEOF_PTHREAD_RWLOCKATTR_T))) {
        private enum enumMixinStr___SIZEOF_PTHREAD_RWLOCKATTR_T = `enum __SIZEOF_PTHREAD_RWLOCKATTR_T = 8;`;
        static if(is(typeof({ mixin(enumMixinStr___SIZEOF_PTHREAD_RWLOCKATTR_T); }))) {
            mixin(enumMixinStr___SIZEOF_PTHREAD_RWLOCKATTR_T);
        }
    }




    static if(!is(typeof(__SIZEOF_PTHREAD_BARRIERATTR_T))) {
        private enum enumMixinStr___SIZEOF_PTHREAD_BARRIERATTR_T = `enum __SIZEOF_PTHREAD_BARRIERATTR_T = 4;`;
        static if(is(typeof({ mixin(enumMixinStr___SIZEOF_PTHREAD_BARRIERATTR_T); }))) {
            mixin(enumMixinStr___SIZEOF_PTHREAD_BARRIERATTR_T);
        }
    }
    static if(!is(typeof(__PTHREAD_MUTEX_LOCK_ELISION))) {
        private enum enumMixinStr___PTHREAD_MUTEX_LOCK_ELISION = `enum __PTHREAD_MUTEX_LOCK_ELISION = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___PTHREAD_MUTEX_LOCK_ELISION); }))) {
            mixin(enumMixinStr___PTHREAD_MUTEX_LOCK_ELISION);
        }
    }




    static if(!is(typeof(__bool_true_false_are_defined))) {
        private enum enumMixinStr___bool_true_false_are_defined = `enum __bool_true_false_are_defined = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___bool_true_false_are_defined); }))) {
            mixin(enumMixinStr___bool_true_false_are_defined);
        }
    }




    static if(!is(typeof(__PTHREAD_MUTEX_NUSERS_AFTER_KIND))) {
        private enum enumMixinStr___PTHREAD_MUTEX_NUSERS_AFTER_KIND = `enum __PTHREAD_MUTEX_NUSERS_AFTER_KIND = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___PTHREAD_MUTEX_NUSERS_AFTER_KIND); }))) {
            mixin(enumMixinStr___PTHREAD_MUTEX_NUSERS_AFTER_KIND);
        }
    }




    static if(!is(typeof(__PTHREAD_MUTEX_USE_UNION))) {
        private enum enumMixinStr___PTHREAD_MUTEX_USE_UNION = `enum __PTHREAD_MUTEX_USE_UNION = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___PTHREAD_MUTEX_USE_UNION); }))) {
            mixin(enumMixinStr___PTHREAD_MUTEX_USE_UNION);
        }
    }
    static if(!is(typeof(false_))) {
        private enum enumMixinStr_false_ = `enum false_ = 0;`;
        static if(is(typeof({ mixin(enumMixinStr_false_); }))) {
            mixin(enumMixinStr_false_);
        }
    }




    static if(!is(typeof(true_))) {
        private enum enumMixinStr_true_ = `enum true_ = 1;`;
        static if(is(typeof({ mixin(enumMixinStr_true_); }))) {
            mixin(enumMixinStr_true_);
        }
    }




    static if(!is(typeof(__PTHREAD_RWLOCK_ELISION_EXTRA))) {
        private enum enumMixinStr___PTHREAD_RWLOCK_ELISION_EXTRA = `enum __PTHREAD_RWLOCK_ELISION_EXTRA = 0 , { 0 , 0 , 0 , 0 , 0 , 0 , 0 };`;
        static if(is(typeof({ mixin(enumMixinStr___PTHREAD_RWLOCK_ELISION_EXTRA); }))) {
            mixin(enumMixinStr___PTHREAD_RWLOCK_ELISION_EXTRA);
        }
    }




    static if(!is(typeof(__PTHREAD_RWLOCK_INT_FLAGS_SHARED))) {
        private enum enumMixinStr___PTHREAD_RWLOCK_INT_FLAGS_SHARED = `enum __PTHREAD_RWLOCK_INT_FLAGS_SHARED = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___PTHREAD_RWLOCK_INT_FLAGS_SHARED); }))) {
            mixin(enumMixinStr___PTHREAD_RWLOCK_INT_FLAGS_SHARED);
        }
    }




    static if(!is(typeof(bool_))) {
        private enum enumMixinStr_bool_ = `enum bool_ = _Bool;`;
        static if(is(typeof({ mixin(enumMixinStr_bool_); }))) {
            mixin(enumMixinStr_bool_);
        }
    }




    static if(!is(typeof(_BITS_PTHREADTYPES_COMMON_H))) {
        private enum enumMixinStr__BITS_PTHREADTYPES_COMMON_H = `enum _BITS_PTHREADTYPES_COMMON_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__BITS_PTHREADTYPES_COMMON_H); }))) {
            mixin(enumMixinStr__BITS_PTHREADTYPES_COMMON_H);
        }
    }






    static if(!is(typeof(__GNUC_VA_LIST))) {
        private enum enumMixinStr___GNUC_VA_LIST = `enum __GNUC_VA_LIST = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___GNUC_VA_LIST); }))) {
            mixin(enumMixinStr___GNUC_VA_LIST);
        }
    }
    static if(!is(typeof(_ALLOCA_H))) {
        private enum enumMixinStr__ALLOCA_H = `enum _ALLOCA_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__ALLOCA_H); }))) {
            mixin(enumMixinStr__ALLOCA_H);
        }
    }




    static if(!is(typeof(WGPUTextureUsage_OUTPUT_ATTACHMENT))) {
        private enum enumMixinStr_WGPUTextureUsage_OUTPUT_ATTACHMENT = `enum WGPUTextureUsage_OUTPUT_ATTACHMENT = cast( uint32_t ) 16;`;
        static if(is(typeof({ mixin(enumMixinStr_WGPUTextureUsage_OUTPUT_ATTACHMENT); }))) {
            mixin(enumMixinStr_WGPUTextureUsage_OUTPUT_ATTACHMENT);
        }
    }




    static if(!is(typeof(WGPUTextureUsage_STORAGE))) {
        private enum enumMixinStr_WGPUTextureUsage_STORAGE = `enum WGPUTextureUsage_STORAGE = cast( uint32_t ) 8;`;
        static if(is(typeof({ mixin(enumMixinStr_WGPUTextureUsage_STORAGE); }))) {
            mixin(enumMixinStr_WGPUTextureUsage_STORAGE);
        }
    }




    static if(!is(typeof(__have_pthread_attr_t))) {
        private enum enumMixinStr___have_pthread_attr_t = `enum __have_pthread_attr_t = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___have_pthread_attr_t); }))) {
            mixin(enumMixinStr___have_pthread_attr_t);
        }
    }




    static if(!is(typeof(WGPUTextureUsage_SAMPLED))) {
        private enum enumMixinStr_WGPUTextureUsage_SAMPLED = `enum WGPUTextureUsage_SAMPLED = cast( uint32_t ) 4;`;
        static if(is(typeof({ mixin(enumMixinStr_WGPUTextureUsage_SAMPLED); }))) {
            mixin(enumMixinStr_WGPUTextureUsage_SAMPLED);
        }
    }




    static if(!is(typeof(WGPUTextureUsage_COPY_DST))) {
        private enum enumMixinStr_WGPUTextureUsage_COPY_DST = `enum WGPUTextureUsage_COPY_DST = cast( uint32_t ) 2;`;
        static if(is(typeof({ mixin(enumMixinStr_WGPUTextureUsage_COPY_DST); }))) {
            mixin(enumMixinStr_WGPUTextureUsage_COPY_DST);
        }
    }




    static if(!is(typeof(WGPUTextureUsage_COPY_SRC))) {
        private enum enumMixinStr_WGPUTextureUsage_COPY_SRC = `enum WGPUTextureUsage_COPY_SRC = cast( uint32_t ) 1;`;
        static if(is(typeof({ mixin(enumMixinStr_WGPUTextureUsage_COPY_SRC); }))) {
            mixin(enumMixinStr_WGPUTextureUsage_COPY_SRC);
        }
    }




    static if(!is(typeof(WGPUColorWrite_ALL))) {
        private enum enumMixinStr_WGPUColorWrite_ALL = `enum WGPUColorWrite_ALL = cast( uint32_t ) 15;`;
        static if(is(typeof({ mixin(enumMixinStr_WGPUColorWrite_ALL); }))) {
            mixin(enumMixinStr_WGPUColorWrite_ALL);
        }
    }




    static if(!is(typeof(WGPUColorWrite_COLOR))) {
        private enum enumMixinStr_WGPUColorWrite_COLOR = `enum WGPUColorWrite_COLOR = cast( uint32_t ) 7;`;
        static if(is(typeof({ mixin(enumMixinStr_WGPUColorWrite_COLOR); }))) {
            mixin(enumMixinStr_WGPUColorWrite_COLOR);
        }
    }




    static if(!is(typeof(WGPUColorWrite_ALPHA))) {
        private enum enumMixinStr_WGPUColorWrite_ALPHA = `enum WGPUColorWrite_ALPHA = cast( uint32_t ) 8;`;
        static if(is(typeof({ mixin(enumMixinStr_WGPUColorWrite_ALPHA); }))) {
            mixin(enumMixinStr_WGPUColorWrite_ALPHA);
        }
    }




    static if(!is(typeof(WGPUColorWrite_BLUE))) {
        private enum enumMixinStr_WGPUColorWrite_BLUE = `enum WGPUColorWrite_BLUE = cast( uint32_t ) 4;`;
        static if(is(typeof({ mixin(enumMixinStr_WGPUColorWrite_BLUE); }))) {
            mixin(enumMixinStr_WGPUColorWrite_BLUE);
        }
    }




    static if(!is(typeof(WGPUColorWrite_GREEN))) {
        private enum enumMixinStr_WGPUColorWrite_GREEN = `enum WGPUColorWrite_GREEN = cast( uint32_t ) 2;`;
        static if(is(typeof({ mixin(enumMixinStr_WGPUColorWrite_GREEN); }))) {
            mixin(enumMixinStr_WGPUColorWrite_GREEN);
        }
    }




    static if(!is(typeof(WGPUColorWrite_RED))) {
        private enum enumMixinStr_WGPUColorWrite_RED = `enum WGPUColorWrite_RED = cast( uint32_t ) 1;`;
        static if(is(typeof({ mixin(enumMixinStr_WGPUColorWrite_RED); }))) {
            mixin(enumMixinStr_WGPUColorWrite_RED);
        }
    }




    static if(!is(typeof(WGPUBufferUsage_INDIRECT))) {
        private enum enumMixinStr_WGPUBufferUsage_INDIRECT = `enum WGPUBufferUsage_INDIRECT = cast( uint32_t ) 256;`;
        static if(is(typeof({ mixin(enumMixinStr_WGPUBufferUsage_INDIRECT); }))) {
            mixin(enumMixinStr_WGPUBufferUsage_INDIRECT);
        }
    }




    static if(!is(typeof(WGPUBufferUsage_STORAGE))) {
        private enum enumMixinStr_WGPUBufferUsage_STORAGE = `enum WGPUBufferUsage_STORAGE = cast( uint32_t ) 128;`;
        static if(is(typeof({ mixin(enumMixinStr_WGPUBufferUsage_STORAGE); }))) {
            mixin(enumMixinStr_WGPUBufferUsage_STORAGE);
        }
    }




    static if(!is(typeof(WGPUBufferUsage_UNIFORM))) {
        private enum enumMixinStr_WGPUBufferUsage_UNIFORM = `enum WGPUBufferUsage_UNIFORM = cast( uint32_t ) 64;`;
        static if(is(typeof({ mixin(enumMixinStr_WGPUBufferUsage_UNIFORM); }))) {
            mixin(enumMixinStr_WGPUBufferUsage_UNIFORM);
        }
    }




    static if(!is(typeof(WGPUBufferUsage_VERTEX))) {
        private enum enumMixinStr_WGPUBufferUsage_VERTEX = `enum WGPUBufferUsage_VERTEX = cast( uint32_t ) 32;`;
        static if(is(typeof({ mixin(enumMixinStr_WGPUBufferUsage_VERTEX); }))) {
            mixin(enumMixinStr_WGPUBufferUsage_VERTEX);
        }
    }




    static if(!is(typeof(WGPUBufferUsage_INDEX))) {
        private enum enumMixinStr_WGPUBufferUsage_INDEX = `enum WGPUBufferUsage_INDEX = cast( uint32_t ) 16;`;
        static if(is(typeof({ mixin(enumMixinStr_WGPUBufferUsage_INDEX); }))) {
            mixin(enumMixinStr_WGPUBufferUsage_INDEX);
        }
    }




    static if(!is(typeof(WGPUBufferUsage_COPY_DST))) {
        private enum enumMixinStr_WGPUBufferUsage_COPY_DST = `enum WGPUBufferUsage_COPY_DST = cast( uint32_t ) 8;`;
        static if(is(typeof({ mixin(enumMixinStr_WGPUBufferUsage_COPY_DST); }))) {
            mixin(enumMixinStr_WGPUBufferUsage_COPY_DST);
        }
    }




    static if(!is(typeof(WGPUBufferUsage_COPY_SRC))) {
        private enum enumMixinStr_WGPUBufferUsage_COPY_SRC = `enum WGPUBufferUsage_COPY_SRC = cast( uint32_t ) 4;`;
        static if(is(typeof({ mixin(enumMixinStr_WGPUBufferUsage_COPY_SRC); }))) {
            mixin(enumMixinStr_WGPUBufferUsage_COPY_SRC);
        }
    }




    static if(!is(typeof(WGPUBufferUsage_MAP_WRITE))) {
        private enum enumMixinStr_WGPUBufferUsage_MAP_WRITE = `enum WGPUBufferUsage_MAP_WRITE = cast( uint32_t ) 2;`;
        static if(is(typeof({ mixin(enumMixinStr_WGPUBufferUsage_MAP_WRITE); }))) {
            mixin(enumMixinStr_WGPUBufferUsage_MAP_WRITE);
        }
    }




    static if(!is(typeof(WGPUBufferUsage_MAP_READ))) {
        private enum enumMixinStr_WGPUBufferUsage_MAP_READ = `enum WGPUBufferUsage_MAP_READ = cast( uint32_t ) 1;`;
        static if(is(typeof({ mixin(enumMixinStr_WGPUBufferUsage_MAP_READ); }))) {
            mixin(enumMixinStr_WGPUBufferUsage_MAP_READ);
        }
    }




    static if(!is(typeof(WGPUShaderStage_COMPUTE))) {
        private enum enumMixinStr_WGPUShaderStage_COMPUTE = `enum WGPUShaderStage_COMPUTE = cast( uint32_t ) 4;`;
        static if(is(typeof({ mixin(enumMixinStr_WGPUShaderStage_COMPUTE); }))) {
            mixin(enumMixinStr_WGPUShaderStage_COMPUTE);
        }
    }




    static if(!is(typeof(WGPUShaderStage_FRAGMENT))) {
        private enum enumMixinStr_WGPUShaderStage_FRAGMENT = `enum WGPUShaderStage_FRAGMENT = cast( uint32_t ) 2;`;
        static if(is(typeof({ mixin(enumMixinStr_WGPUShaderStage_FRAGMENT); }))) {
            mixin(enumMixinStr_WGPUShaderStage_FRAGMENT);
        }
    }




    static if(!is(typeof(WGPUShaderStage_VERTEX))) {
        private enum enumMixinStr_WGPUShaderStage_VERTEX = `enum WGPUShaderStage_VERTEX = cast( uint32_t ) 1;`;
        static if(is(typeof({ mixin(enumMixinStr_WGPUShaderStage_VERTEX); }))) {
            mixin(enumMixinStr_WGPUShaderStage_VERTEX);
        }
    }




    static if(!is(typeof(WGPUShaderStage_NONE))) {
        private enum enumMixinStr_WGPUShaderStage_NONE = `enum WGPUShaderStage_NONE = cast( uint32_t ) 0;`;
        static if(is(typeof({ mixin(enumMixinStr_WGPUShaderStage_NONE); }))) {
            mixin(enumMixinStr_WGPUShaderStage_NONE);
        }
    }




    static if(!is(typeof(WGPUOrigin3d_ZERO))) {
        private enum enumMixinStr_WGPUOrigin3d_ZERO = `enum WGPUOrigin3d_ZERO = cast( WGPUOrigin3d ) { . x = 0 , . y = 0 , . z = 0 };`;
        static if(is(typeof({ mixin(enumMixinStr_WGPUOrigin3d_ZERO); }))) {
            mixin(enumMixinStr_WGPUOrigin3d_ZERO);
        }
    }




    static if(!is(typeof(WGPUColor_BLUE))) {
        private enum enumMixinStr_WGPUColor_BLUE = `enum WGPUColor_BLUE = cast( WGPUColor ) { . r = 0.0 , . g = 0.0 , . b = 1.0 , . a = 1.0 };`;
        static if(is(typeof({ mixin(enumMixinStr_WGPUColor_BLUE); }))) {
            mixin(enumMixinStr_WGPUColor_BLUE);
        }
    }




    static if(!is(typeof(WGPUColor_GREEN))) {
        private enum enumMixinStr_WGPUColor_GREEN = `enum WGPUColor_GREEN = cast( WGPUColor ) { . r = 0.0 , . g = 1.0 , . b = 0.0 , . a = 1.0 };`;
        static if(is(typeof({ mixin(enumMixinStr_WGPUColor_GREEN); }))) {
            mixin(enumMixinStr_WGPUColor_GREEN);
        }
    }




    static if(!is(typeof(WGPUColor_RED))) {
        private enum enumMixinStr_WGPUColor_RED = `enum WGPUColor_RED = cast( WGPUColor ) { . r = 1.0 , . g = 0.0 , . b = 0.0 , . a = 1.0 };`;
        static if(is(typeof({ mixin(enumMixinStr_WGPUColor_RED); }))) {
            mixin(enumMixinStr_WGPUColor_RED);
        }
    }




    static if(!is(typeof(__FD_ZERO_STOS))) {
        private enum enumMixinStr___FD_ZERO_STOS = `enum __FD_ZERO_STOS = "stosq";`;
        static if(is(typeof({ mixin(enumMixinStr___FD_ZERO_STOS); }))) {
            mixin(enumMixinStr___FD_ZERO_STOS);
        }
    }
    static if(!is(typeof(_BITS_STDINT_INTN_H))) {
        private enum enumMixinStr__BITS_STDINT_INTN_H = `enum _BITS_STDINT_INTN_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__BITS_STDINT_INTN_H); }))) {
            mixin(enumMixinStr__BITS_STDINT_INTN_H);
        }
    }




    static if(!is(typeof(WGPUColor_WHITE))) {
        private enum enumMixinStr_WGPUColor_WHITE = `enum WGPUColor_WHITE = cast( WGPUColor ) { . r = 1.0 , . g = 1.0 , . b = 1.0 , . a = 1.0 };`;
        static if(is(typeof({ mixin(enumMixinStr_WGPUColor_WHITE); }))) {
            mixin(enumMixinStr_WGPUColor_WHITE);
        }
    }




    static if(!is(typeof(WGPUColor_BLACK))) {
        private enum enumMixinStr_WGPUColor_BLACK = `enum WGPUColor_BLACK = cast( WGPUColor ) { . r = 0.0 , . g = 0.0 , . b = 0.0 , . a = 1.0 };`;
        static if(is(typeof({ mixin(enumMixinStr_WGPUColor_BLACK); }))) {
            mixin(enumMixinStr_WGPUColor_BLACK);
        }
    }




    static if(!is(typeof(WGPUColor_TRANSPARENT))) {
        private enum enumMixinStr_WGPUColor_TRANSPARENT = `enum WGPUColor_TRANSPARENT = cast( WGPUColor ) { . r = 0.0 , . g = 0.0 , . b = 0.0 , . a = 0.0 };`;
        static if(is(typeof({ mixin(enumMixinStr_WGPUColor_TRANSPARENT); }))) {
            mixin(enumMixinStr_WGPUColor_TRANSPARENT);
        }
    }




    static if(!is(typeof(WGPUFeatures_ALL_NATIVE))) {
        private enum enumMixinStr_WGPUFeatures_ALL_NATIVE = `enum WGPUFeatures_ALL_NATIVE = cast( uint64_t ) 18446744073709486080ULL;`;
        static if(is(typeof({ mixin(enumMixinStr_WGPUFeatures_ALL_NATIVE); }))) {
            mixin(enumMixinStr_WGPUFeatures_ALL_NATIVE);
        }
    }




    static if(!is(typeof(WGPUFeatures_ALL_UNSAFE))) {
        private enum enumMixinStr_WGPUFeatures_ALL_UNSAFE = `enum WGPUFeatures_ALL_UNSAFE = cast( uint64_t ) 18446462598732840960ULL;`;
        static if(is(typeof({ mixin(enumMixinStr_WGPUFeatures_ALL_UNSAFE); }))) {
            mixin(enumMixinStr_WGPUFeatures_ALL_UNSAFE);
        }
    }




    static if(!is(typeof(_BITS_STDINT_UINTN_H))) {
        private enum enumMixinStr__BITS_STDINT_UINTN_H = `enum _BITS_STDINT_UINTN_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__BITS_STDINT_UINTN_H); }))) {
            mixin(enumMixinStr__BITS_STDINT_UINTN_H);
        }
    }




    static if(!is(typeof(WGPUFeatures_ALL_WEBGPU))) {
        private enum enumMixinStr_WGPUFeatures_ALL_WEBGPU = `enum WGPUFeatures_ALL_WEBGPU = cast( uint64_t ) 65535;`;
        static if(is(typeof({ mixin(enumMixinStr_WGPUFeatures_ALL_WEBGPU); }))) {
            mixin(enumMixinStr_WGPUFeatures_ALL_WEBGPU);
        }
    }




    static if(!is(typeof(WGPUFeatures_MULTI_DRAW_INDIRECT_COUNT))) {
        private enum enumMixinStr_WGPUFeatures_MULTI_DRAW_INDIRECT_COUNT = `enum WGPUFeatures_MULTI_DRAW_INDIRECT_COUNT = cast( uint64_t ) 4194304;`;
        static if(is(typeof({ mixin(enumMixinStr_WGPUFeatures_MULTI_DRAW_INDIRECT_COUNT); }))) {
            mixin(enumMixinStr_WGPUFeatures_MULTI_DRAW_INDIRECT_COUNT);
        }
    }




    static if(!is(typeof(WGPUFeatures_MULTI_DRAW_INDIRECT))) {
        private enum enumMixinStr_WGPUFeatures_MULTI_DRAW_INDIRECT = `enum WGPUFeatures_MULTI_DRAW_INDIRECT = cast( uint64_t ) 2097152;`;
        static if(is(typeof({ mixin(enumMixinStr_WGPUFeatures_MULTI_DRAW_INDIRECT); }))) {
            mixin(enumMixinStr_WGPUFeatures_MULTI_DRAW_INDIRECT);
        }
    }




    static if(!is(typeof(WGPUFeatures_UNSIZED_BINDING_ARRAY))) {
        private enum enumMixinStr_WGPUFeatures_UNSIZED_BINDING_ARRAY = `enum WGPUFeatures_UNSIZED_BINDING_ARRAY = cast( uint64_t ) 1048576;`;
        static if(is(typeof({ mixin(enumMixinStr_WGPUFeatures_UNSIZED_BINDING_ARRAY); }))) {
            mixin(enumMixinStr_WGPUFeatures_UNSIZED_BINDING_ARRAY);
        }
    }




    static if(!is(typeof(WGPUFeatures_SAMPLED_TEXTURE_ARRAY_NON_UNIFORM_INDEXING))) {
        private enum enumMixinStr_WGPUFeatures_SAMPLED_TEXTURE_ARRAY_NON_UNIFORM_INDEXING = `enum WGPUFeatures_SAMPLED_TEXTURE_ARRAY_NON_UNIFORM_INDEXING = cast( uint64_t ) 524288;`;
        static if(is(typeof({ mixin(enumMixinStr_WGPUFeatures_SAMPLED_TEXTURE_ARRAY_NON_UNIFORM_INDEXING); }))) {
            mixin(enumMixinStr_WGPUFeatures_SAMPLED_TEXTURE_ARRAY_NON_UNIFORM_INDEXING);
        }
    }




    static if(!is(typeof(WGPUFeatures_SAMPLED_TEXTURE_ARRAY_DYNAMIC_INDEXING))) {
        private enum enumMixinStr_WGPUFeatures_SAMPLED_TEXTURE_ARRAY_DYNAMIC_INDEXING = `enum WGPUFeatures_SAMPLED_TEXTURE_ARRAY_DYNAMIC_INDEXING = cast( uint64_t ) 262144;`;
        static if(is(typeof({ mixin(enumMixinStr_WGPUFeatures_SAMPLED_TEXTURE_ARRAY_DYNAMIC_INDEXING); }))) {
            mixin(enumMixinStr_WGPUFeatures_SAMPLED_TEXTURE_ARRAY_DYNAMIC_INDEXING);
        }
    }




    static if(!is(typeof(_BITS_SYSMACROS_H))) {
        private enum enumMixinStr__BITS_SYSMACROS_H = `enum _BITS_SYSMACROS_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__BITS_SYSMACROS_H); }))) {
            mixin(enumMixinStr__BITS_SYSMACROS_H);
        }
    }




    static if(!is(typeof(WGPUFeatures_SAMPLED_TEXTURE_BINDING_ARRAY))) {
        private enum enumMixinStr_WGPUFeatures_SAMPLED_TEXTURE_BINDING_ARRAY = `enum WGPUFeatures_SAMPLED_TEXTURE_BINDING_ARRAY = cast( uint64_t ) 131072;`;
        static if(is(typeof({ mixin(enumMixinStr_WGPUFeatures_SAMPLED_TEXTURE_BINDING_ARRAY); }))) {
            mixin(enumMixinStr_WGPUFeatures_SAMPLED_TEXTURE_BINDING_ARRAY);
        }
    }




    static if(!is(typeof(__SYSMACROS_DECLARE_MAJOR))) {
        private enum enumMixinStr___SYSMACROS_DECLARE_MAJOR = `enum __SYSMACROS_DECLARE_MAJOR = ( DECL_TEMPL ) DECL_TEMPL ( unsigned int , major , ( __dev_t __dev ) );`;
        static if(is(typeof({ mixin(enumMixinStr___SYSMACROS_DECLARE_MAJOR); }))) {
            mixin(enumMixinStr___SYSMACROS_DECLARE_MAJOR);
        }
    }




    static if(!is(typeof(__SYSMACROS_DEFINE_MAJOR))) {
        private enum enumMixinStr___SYSMACROS_DEFINE_MAJOR = `enum __SYSMACROS_DEFINE_MAJOR = ( DECL_TEMPL ) ( DECL_TEMPL ) DECL_TEMPL ( unsigned int , major , ( __dev_t __dev ) ) ( DECL_TEMPL ) { unsigned int __major ; __major = ( ( __dev & cast( __dev_t ) 0x00000000000fff00u ) >> 8 ) ; __major |= ( ( __dev & cast( __dev_t ) 0xfffff00000000000u ) >> 32 ) ; return __major ; };`;
        static if(is(typeof({ mixin(enumMixinStr___SYSMACROS_DEFINE_MAJOR); }))) {
            mixin(enumMixinStr___SYSMACROS_DEFINE_MAJOR);
        }
    }




    static if(!is(typeof(__SYSMACROS_DECLARE_MINOR))) {
        private enum enumMixinStr___SYSMACROS_DECLARE_MINOR = `enum __SYSMACROS_DECLARE_MINOR = ( DECL_TEMPL ) DECL_TEMPL ( unsigned int , minor , ( __dev_t __dev ) );`;
        static if(is(typeof({ mixin(enumMixinStr___SYSMACROS_DECLARE_MINOR); }))) {
            mixin(enumMixinStr___SYSMACROS_DECLARE_MINOR);
        }
    }




    static if(!is(typeof(__SYSMACROS_DEFINE_MINOR))) {
        private enum enumMixinStr___SYSMACROS_DEFINE_MINOR = `enum __SYSMACROS_DEFINE_MINOR = ( DECL_TEMPL ) ( DECL_TEMPL ) DECL_TEMPL ( unsigned int , minor , ( __dev_t __dev ) ) ( DECL_TEMPL ) { unsigned int __minor ; __minor = ( ( __dev & cast( __dev_t ) 0x00000000000000ffu ) >> 0 ) ; __minor |= ( ( __dev & cast( __dev_t ) 0x00000ffffff00000u ) >> 12 ) ; return __minor ; };`;
        static if(is(typeof({ mixin(enumMixinStr___SYSMACROS_DEFINE_MINOR); }))) {
            mixin(enumMixinStr___SYSMACROS_DEFINE_MINOR);
        }
    }




    static if(!is(typeof(__SYSMACROS_DECLARE_MAKEDEV))) {
        private enum enumMixinStr___SYSMACROS_DECLARE_MAKEDEV = `enum __SYSMACROS_DECLARE_MAKEDEV = ( DECL_TEMPL ) DECL_TEMPL ( __dev_t , makedev , ( unsigned int __major , unsigned int __minor ) );`;
        static if(is(typeof({ mixin(enumMixinStr___SYSMACROS_DECLARE_MAKEDEV); }))) {
            mixin(enumMixinStr___SYSMACROS_DECLARE_MAKEDEV);
        }
    }




    static if(!is(typeof(__SYSMACROS_DEFINE_MAKEDEV))) {
        private enum enumMixinStr___SYSMACROS_DEFINE_MAKEDEV = `enum __SYSMACROS_DEFINE_MAKEDEV = ( DECL_TEMPL ) ( DECL_TEMPL ) DECL_TEMPL ( __dev_t , makedev , ( unsigned int __major , unsigned int __minor ) ) ( DECL_TEMPL ) { __dev_t __dev ; __dev = ( ( cast( __dev_t ) ( __major & 0x00000fffu ) ) << 8 ) ; __dev |= ( ( cast( __dev_t ) ( __major & 0xfffff000u ) ) << 32 ) ; __dev |= ( ( cast( __dev_t ) ( __minor & 0x000000ffu ) ) << 0 ) ; __dev |= ( ( cast( __dev_t ) ( __minor & 0xffffff00u ) ) << 12 ) ; return __dev ; };`;
        static if(is(typeof({ mixin(enumMixinStr___SYSMACROS_DEFINE_MAKEDEV); }))) {
            mixin(enumMixinStr___SYSMACROS_DEFINE_MAKEDEV);
        }
    }




    static if(!is(typeof(_THREAD_SHARED_TYPES_H))) {
        private enum enumMixinStr__THREAD_SHARED_TYPES_H = `enum _THREAD_SHARED_TYPES_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__THREAD_SHARED_TYPES_H); }))) {
            mixin(enumMixinStr__THREAD_SHARED_TYPES_H);
        }
    }




    static if(!is(typeof(WGPUFeatures_MAPPABLE_PRIMARY_BUFFERS))) {
        private enum enumMixinStr_WGPUFeatures_MAPPABLE_PRIMARY_BUFFERS = `enum WGPUFeatures_MAPPABLE_PRIMARY_BUFFERS = cast( uint64_t ) 65536;`;
        static if(is(typeof({ mixin(enumMixinStr_WGPUFeatures_MAPPABLE_PRIMARY_BUFFERS); }))) {
            mixin(enumMixinStr_WGPUFeatures_MAPPABLE_PRIMARY_BUFFERS);
        }
    }




    static if(!is(typeof(WGPUMAX_VERTEX_BUFFERS))) {
        private enum enumMixinStr_WGPUMAX_VERTEX_BUFFERS = `enum WGPUMAX_VERTEX_BUFFERS = 16;`;
        static if(is(typeof({ mixin(enumMixinStr_WGPUMAX_VERTEX_BUFFERS); }))) {
            mixin(enumMixinStr_WGPUMAX_VERTEX_BUFFERS);
        }
    }




    static if(!is(typeof(WGPUMAX_MIP_LEVELS))) {
        private enum enumMixinStr_WGPUMAX_MIP_LEVELS = `enum WGPUMAX_MIP_LEVELS = 16;`;
        static if(is(typeof({ mixin(enumMixinStr_WGPUMAX_MIP_LEVELS); }))) {
            mixin(enumMixinStr_WGPUMAX_MIP_LEVELS);
        }
    }




    static if(!is(typeof(WGPUMAX_COLOR_TARGETS))) {
        private enum enumMixinStr_WGPUMAX_COLOR_TARGETS = `enum WGPUMAX_COLOR_TARGETS = 4;`;
        static if(is(typeof({ mixin(enumMixinStr_WGPUMAX_COLOR_TARGETS); }))) {
            mixin(enumMixinStr_WGPUMAX_COLOR_TARGETS);
        }
    }




    static if(!is(typeof(WGPUMAX_ANISOTROPY))) {
        private enum enumMixinStr_WGPUMAX_ANISOTROPY = `enum WGPUMAX_ANISOTROPY = 16;`;
        static if(is(typeof({ mixin(enumMixinStr_WGPUMAX_ANISOTROPY); }))) {
            mixin(enumMixinStr_WGPUMAX_ANISOTROPY);
        }
    }




    static if(!is(typeof(WGPUDESIRED_NUM_FRAMES))) {
        private enum enumMixinStr_WGPUDESIRED_NUM_FRAMES = `enum WGPUDESIRED_NUM_FRAMES = 3;`;
        static if(is(typeof({ mixin(enumMixinStr_WGPUDESIRED_NUM_FRAMES); }))) {
            mixin(enumMixinStr_WGPUDESIRED_NUM_FRAMES);
        }
    }




    static if(!is(typeof(__PTHREAD_SPINS_DATA))) {
        private enum enumMixinStr___PTHREAD_SPINS_DATA = `enum __PTHREAD_SPINS_DATA = short __spins ; short __elision;`;
        static if(is(typeof({ mixin(enumMixinStr___PTHREAD_SPINS_DATA); }))) {
            mixin(enumMixinStr___PTHREAD_SPINS_DATA);
        }
    }




    static if(!is(typeof(__PTHREAD_SPINS))) {
        private enum enumMixinStr___PTHREAD_SPINS = `enum __PTHREAD_SPINS = 0 , 0;`;
        static if(is(typeof({ mixin(enumMixinStr___PTHREAD_SPINS); }))) {
            mixin(enumMixinStr___PTHREAD_SPINS);
        }
    }




    static if(!is(typeof(WGPUCOPY_BYTES_PER_ROW_ALIGNMENT))) {
        private enum enumMixinStr_WGPUCOPY_BYTES_PER_ROW_ALIGNMENT = `enum WGPUCOPY_BYTES_PER_ROW_ALIGNMENT = 256;`;
        static if(is(typeof({ mixin(enumMixinStr_WGPUCOPY_BYTES_PER_ROW_ALIGNMENT); }))) {
            mixin(enumMixinStr_WGPUCOPY_BYTES_PER_ROW_ALIGNMENT);
        }
    }




    static if(!is(typeof(__PTHREAD_MUTEX_HAVE_PREV))) {
        private enum enumMixinStr___PTHREAD_MUTEX_HAVE_PREV = `enum __PTHREAD_MUTEX_HAVE_PREV = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___PTHREAD_MUTEX_HAVE_PREV); }))) {
            mixin(enumMixinStr___PTHREAD_MUTEX_HAVE_PREV);
        }
    }




    static if(!is(typeof(_BITS_TYPES_H))) {
        private enum enumMixinStr__BITS_TYPES_H = `enum _BITS_TYPES_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__BITS_TYPES_H); }))) {
            mixin(enumMixinStr__BITS_TYPES_H);
        }
    }




    static if(!is(typeof(__S16_TYPE))) {
        private enum enumMixinStr___S16_TYPE = `enum __S16_TYPE = short int;`;
        static if(is(typeof({ mixin(enumMixinStr___S16_TYPE); }))) {
            mixin(enumMixinStr___S16_TYPE);
        }
    }




    static if(!is(typeof(__U16_TYPE))) {
        private enum enumMixinStr___U16_TYPE = `enum __U16_TYPE = unsigned short int;`;
        static if(is(typeof({ mixin(enumMixinStr___U16_TYPE); }))) {
            mixin(enumMixinStr___U16_TYPE);
        }
    }




    static if(!is(typeof(__S32_TYPE))) {
        private enum enumMixinStr___S32_TYPE = `enum __S32_TYPE = int;`;
        static if(is(typeof({ mixin(enumMixinStr___S32_TYPE); }))) {
            mixin(enumMixinStr___S32_TYPE);
        }
    }




    static if(!is(typeof(__U32_TYPE))) {
        private enum enumMixinStr___U32_TYPE = `enum __U32_TYPE = unsigned int;`;
        static if(is(typeof({ mixin(enumMixinStr___U32_TYPE); }))) {
            mixin(enumMixinStr___U32_TYPE);
        }
    }




    static if(!is(typeof(__SLONGWORD_TYPE))) {
        private enum enumMixinStr___SLONGWORD_TYPE = `enum __SLONGWORD_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___SLONGWORD_TYPE); }))) {
            mixin(enumMixinStr___SLONGWORD_TYPE);
        }
    }




    static if(!is(typeof(__ULONGWORD_TYPE))) {
        private enum enumMixinStr___ULONGWORD_TYPE = `enum __ULONGWORD_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___ULONGWORD_TYPE); }))) {
            mixin(enumMixinStr___ULONGWORD_TYPE);
        }
    }




    static if(!is(typeof(__SQUAD_TYPE))) {
        private enum enumMixinStr___SQUAD_TYPE = `enum __SQUAD_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___SQUAD_TYPE); }))) {
            mixin(enumMixinStr___SQUAD_TYPE);
        }
    }




    static if(!is(typeof(__UQUAD_TYPE))) {
        private enum enumMixinStr___UQUAD_TYPE = `enum __UQUAD_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___UQUAD_TYPE); }))) {
            mixin(enumMixinStr___UQUAD_TYPE);
        }
    }




    static if(!is(typeof(__SWORD_TYPE))) {
        private enum enumMixinStr___SWORD_TYPE = `enum __SWORD_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___SWORD_TYPE); }))) {
            mixin(enumMixinStr___SWORD_TYPE);
        }
    }




    static if(!is(typeof(__UWORD_TYPE))) {
        private enum enumMixinStr___UWORD_TYPE = `enum __UWORD_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___UWORD_TYPE); }))) {
            mixin(enumMixinStr___UWORD_TYPE);
        }
    }




    static if(!is(typeof(__SLONG32_TYPE))) {
        private enum enumMixinStr___SLONG32_TYPE = `enum __SLONG32_TYPE = int;`;
        static if(is(typeof({ mixin(enumMixinStr___SLONG32_TYPE); }))) {
            mixin(enumMixinStr___SLONG32_TYPE);
        }
    }




    static if(!is(typeof(__ULONG32_TYPE))) {
        private enum enumMixinStr___ULONG32_TYPE = `enum __ULONG32_TYPE = unsigned int;`;
        static if(is(typeof({ mixin(enumMixinStr___ULONG32_TYPE); }))) {
            mixin(enumMixinStr___ULONG32_TYPE);
        }
    }




    static if(!is(typeof(__S64_TYPE))) {
        private enum enumMixinStr___S64_TYPE = `enum __S64_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___S64_TYPE); }))) {
            mixin(enumMixinStr___S64_TYPE);
        }
    }




    static if(!is(typeof(__U64_TYPE))) {
        private enum enumMixinStr___U64_TYPE = `enum __U64_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___U64_TYPE); }))) {
            mixin(enumMixinStr___U64_TYPE);
        }
    }




    static if(!is(typeof(__STD_TYPE))) {
        private enum enumMixinStr___STD_TYPE = `enum __STD_TYPE = typedef;`;
        static if(is(typeof({ mixin(enumMixinStr___STD_TYPE); }))) {
            mixin(enumMixinStr___STD_TYPE);
        }
    }






    static if(!is(typeof(_SIGSET_NWORDS))) {
        private enum enumMixinStr__SIGSET_NWORDS = `enum _SIGSET_NWORDS = ( 1024 / ( 8 * ( unsigned long int ) .sizeof ) );`;
        static if(is(typeof({ mixin(enumMixinStr__SIGSET_NWORDS); }))) {
            mixin(enumMixinStr__SIGSET_NWORDS);
        }
    }




    static if(!is(typeof(__clock_t_defined))) {
        private enum enumMixinStr___clock_t_defined = `enum __clock_t_defined = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___clock_t_defined); }))) {
            mixin(enumMixinStr___clock_t_defined);
        }
    }




    static if(!is(typeof(__clockid_t_defined))) {
        private enum enumMixinStr___clockid_t_defined = `enum __clockid_t_defined = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___clockid_t_defined); }))) {
            mixin(enumMixinStr___clockid_t_defined);
        }
    }




    static if(!is(typeof(__sigset_t_defined))) {
        private enum enumMixinStr___sigset_t_defined = `enum __sigset_t_defined = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___sigset_t_defined); }))) {
            mixin(enumMixinStr___sigset_t_defined);
        }
    }




    static if(!is(typeof(__timespec_defined))) {
        private enum enumMixinStr___timespec_defined = `enum __timespec_defined = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___timespec_defined); }))) {
            mixin(enumMixinStr___timespec_defined);
        }
    }




    static if(!is(typeof(__timeval_defined))) {
        private enum enumMixinStr___timeval_defined = `enum __timeval_defined = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___timeval_defined); }))) {
            mixin(enumMixinStr___timeval_defined);
        }
    }




    static if(!is(typeof(__time_t_defined))) {
        private enum enumMixinStr___time_t_defined = `enum __time_t_defined = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___time_t_defined); }))) {
            mixin(enumMixinStr___time_t_defined);
        }
    }




    static if(!is(typeof(__timer_t_defined))) {
        private enum enumMixinStr___timer_t_defined = `enum __timer_t_defined = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___timer_t_defined); }))) {
            mixin(enumMixinStr___timer_t_defined);
        }
    }




    static if(!is(typeof(_BITS_TYPESIZES_H))) {
        private enum enumMixinStr__BITS_TYPESIZES_H = `enum _BITS_TYPESIZES_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__BITS_TYPESIZES_H); }))) {
            mixin(enumMixinStr__BITS_TYPESIZES_H);
        }
    }




    static if(!is(typeof(__SYSCALL_SLONG_TYPE))) {
        private enum enumMixinStr___SYSCALL_SLONG_TYPE = `enum __SYSCALL_SLONG_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___SYSCALL_SLONG_TYPE); }))) {
            mixin(enumMixinStr___SYSCALL_SLONG_TYPE);
        }
    }




    static if(!is(typeof(__SYSCALL_ULONG_TYPE))) {
        private enum enumMixinStr___SYSCALL_ULONG_TYPE = `enum __SYSCALL_ULONG_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___SYSCALL_ULONG_TYPE); }))) {
            mixin(enumMixinStr___SYSCALL_ULONG_TYPE);
        }
    }




    static if(!is(typeof(__DEV_T_TYPE))) {
        private enum enumMixinStr___DEV_T_TYPE = `enum __DEV_T_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___DEV_T_TYPE); }))) {
            mixin(enumMixinStr___DEV_T_TYPE);
        }
    }




    static if(!is(typeof(__UID_T_TYPE))) {
        private enum enumMixinStr___UID_T_TYPE = `enum __UID_T_TYPE = unsigned int;`;
        static if(is(typeof({ mixin(enumMixinStr___UID_T_TYPE); }))) {
            mixin(enumMixinStr___UID_T_TYPE);
        }
    }




    static if(!is(typeof(__GID_T_TYPE))) {
        private enum enumMixinStr___GID_T_TYPE = `enum __GID_T_TYPE = unsigned int;`;
        static if(is(typeof({ mixin(enumMixinStr___GID_T_TYPE); }))) {
            mixin(enumMixinStr___GID_T_TYPE);
        }
    }




    static if(!is(typeof(__INO_T_TYPE))) {
        private enum enumMixinStr___INO_T_TYPE = `enum __INO_T_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___INO_T_TYPE); }))) {
            mixin(enumMixinStr___INO_T_TYPE);
        }
    }




    static if(!is(typeof(__INO64_T_TYPE))) {
        private enum enumMixinStr___INO64_T_TYPE = `enum __INO64_T_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___INO64_T_TYPE); }))) {
            mixin(enumMixinStr___INO64_T_TYPE);
        }
    }




    static if(!is(typeof(__MODE_T_TYPE))) {
        private enum enumMixinStr___MODE_T_TYPE = `enum __MODE_T_TYPE = unsigned int;`;
        static if(is(typeof({ mixin(enumMixinStr___MODE_T_TYPE); }))) {
            mixin(enumMixinStr___MODE_T_TYPE);
        }
    }




    static if(!is(typeof(__NLINK_T_TYPE))) {
        private enum enumMixinStr___NLINK_T_TYPE = `enum __NLINK_T_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___NLINK_T_TYPE); }))) {
            mixin(enumMixinStr___NLINK_T_TYPE);
        }
    }




    static if(!is(typeof(__FSWORD_T_TYPE))) {
        private enum enumMixinStr___FSWORD_T_TYPE = `enum __FSWORD_T_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___FSWORD_T_TYPE); }))) {
            mixin(enumMixinStr___FSWORD_T_TYPE);
        }
    }




    static if(!is(typeof(__OFF_T_TYPE))) {
        private enum enumMixinStr___OFF_T_TYPE = `enum __OFF_T_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___OFF_T_TYPE); }))) {
            mixin(enumMixinStr___OFF_T_TYPE);
        }
    }




    static if(!is(typeof(__OFF64_T_TYPE))) {
        private enum enumMixinStr___OFF64_T_TYPE = `enum __OFF64_T_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___OFF64_T_TYPE); }))) {
            mixin(enumMixinStr___OFF64_T_TYPE);
        }
    }




    static if(!is(typeof(__PID_T_TYPE))) {
        private enum enumMixinStr___PID_T_TYPE = `enum __PID_T_TYPE = int;`;
        static if(is(typeof({ mixin(enumMixinStr___PID_T_TYPE); }))) {
            mixin(enumMixinStr___PID_T_TYPE);
        }
    }




    static if(!is(typeof(__RLIM_T_TYPE))) {
        private enum enumMixinStr___RLIM_T_TYPE = `enum __RLIM_T_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___RLIM_T_TYPE); }))) {
            mixin(enumMixinStr___RLIM_T_TYPE);
        }
    }




    static if(!is(typeof(__RLIM64_T_TYPE))) {
        private enum enumMixinStr___RLIM64_T_TYPE = `enum __RLIM64_T_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___RLIM64_T_TYPE); }))) {
            mixin(enumMixinStr___RLIM64_T_TYPE);
        }
    }




    static if(!is(typeof(__BLKCNT_T_TYPE))) {
        private enum enumMixinStr___BLKCNT_T_TYPE = `enum __BLKCNT_T_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___BLKCNT_T_TYPE); }))) {
            mixin(enumMixinStr___BLKCNT_T_TYPE);
        }
    }




    static if(!is(typeof(__BLKCNT64_T_TYPE))) {
        private enum enumMixinStr___BLKCNT64_T_TYPE = `enum __BLKCNT64_T_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___BLKCNT64_T_TYPE); }))) {
            mixin(enumMixinStr___BLKCNT64_T_TYPE);
        }
    }




    static if(!is(typeof(__FSBLKCNT_T_TYPE))) {
        private enum enumMixinStr___FSBLKCNT_T_TYPE = `enum __FSBLKCNT_T_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___FSBLKCNT_T_TYPE); }))) {
            mixin(enumMixinStr___FSBLKCNT_T_TYPE);
        }
    }




    static if(!is(typeof(__FSBLKCNT64_T_TYPE))) {
        private enum enumMixinStr___FSBLKCNT64_T_TYPE = `enum __FSBLKCNT64_T_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___FSBLKCNT64_T_TYPE); }))) {
            mixin(enumMixinStr___FSBLKCNT64_T_TYPE);
        }
    }




    static if(!is(typeof(__FSFILCNT_T_TYPE))) {
        private enum enumMixinStr___FSFILCNT_T_TYPE = `enum __FSFILCNT_T_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___FSFILCNT_T_TYPE); }))) {
            mixin(enumMixinStr___FSFILCNT_T_TYPE);
        }
    }




    static if(!is(typeof(__FSFILCNT64_T_TYPE))) {
        private enum enumMixinStr___FSFILCNT64_T_TYPE = `enum __FSFILCNT64_T_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___FSFILCNT64_T_TYPE); }))) {
            mixin(enumMixinStr___FSFILCNT64_T_TYPE);
        }
    }




    static if(!is(typeof(__ID_T_TYPE))) {
        private enum enumMixinStr___ID_T_TYPE = `enum __ID_T_TYPE = unsigned int;`;
        static if(is(typeof({ mixin(enumMixinStr___ID_T_TYPE); }))) {
            mixin(enumMixinStr___ID_T_TYPE);
        }
    }




    static if(!is(typeof(__CLOCK_T_TYPE))) {
        private enum enumMixinStr___CLOCK_T_TYPE = `enum __CLOCK_T_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___CLOCK_T_TYPE); }))) {
            mixin(enumMixinStr___CLOCK_T_TYPE);
        }
    }




    static if(!is(typeof(__TIME_T_TYPE))) {
        private enum enumMixinStr___TIME_T_TYPE = `enum __TIME_T_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___TIME_T_TYPE); }))) {
            mixin(enumMixinStr___TIME_T_TYPE);
        }
    }




    static if(!is(typeof(__USECONDS_T_TYPE))) {
        private enum enumMixinStr___USECONDS_T_TYPE = `enum __USECONDS_T_TYPE = unsigned int;`;
        static if(is(typeof({ mixin(enumMixinStr___USECONDS_T_TYPE); }))) {
            mixin(enumMixinStr___USECONDS_T_TYPE);
        }
    }




    static if(!is(typeof(__SUSECONDS_T_TYPE))) {
        private enum enumMixinStr___SUSECONDS_T_TYPE = `enum __SUSECONDS_T_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___SUSECONDS_T_TYPE); }))) {
            mixin(enumMixinStr___SUSECONDS_T_TYPE);
        }
    }




    static if(!is(typeof(__DADDR_T_TYPE))) {
        private enum enumMixinStr___DADDR_T_TYPE = `enum __DADDR_T_TYPE = int;`;
        static if(is(typeof({ mixin(enumMixinStr___DADDR_T_TYPE); }))) {
            mixin(enumMixinStr___DADDR_T_TYPE);
        }
    }




    static if(!is(typeof(__KEY_T_TYPE))) {
        private enum enumMixinStr___KEY_T_TYPE = `enum __KEY_T_TYPE = int;`;
        static if(is(typeof({ mixin(enumMixinStr___KEY_T_TYPE); }))) {
            mixin(enumMixinStr___KEY_T_TYPE);
        }
    }




    static if(!is(typeof(__CLOCKID_T_TYPE))) {
        private enum enumMixinStr___CLOCKID_T_TYPE = `enum __CLOCKID_T_TYPE = int;`;
        static if(is(typeof({ mixin(enumMixinStr___CLOCKID_T_TYPE); }))) {
            mixin(enumMixinStr___CLOCKID_T_TYPE);
        }
    }




    static if(!is(typeof(__TIMER_T_TYPE))) {
        private enum enumMixinStr___TIMER_T_TYPE = `enum __TIMER_T_TYPE = void *;`;
        static if(is(typeof({ mixin(enumMixinStr___TIMER_T_TYPE); }))) {
            mixin(enumMixinStr___TIMER_T_TYPE);
        }
    }




    static if(!is(typeof(__BLKSIZE_T_TYPE))) {
        private enum enumMixinStr___BLKSIZE_T_TYPE = `enum __BLKSIZE_T_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___BLKSIZE_T_TYPE); }))) {
            mixin(enumMixinStr___BLKSIZE_T_TYPE);
        }
    }




    static if(!is(typeof(__FSID_T_TYPE))) {
        private enum enumMixinStr___FSID_T_TYPE = `enum __FSID_T_TYPE = { int __val [ 2 ] ; };`;
        static if(is(typeof({ mixin(enumMixinStr___FSID_T_TYPE); }))) {
            mixin(enumMixinStr___FSID_T_TYPE);
        }
    }




    static if(!is(typeof(__SSIZE_T_TYPE))) {
        private enum enumMixinStr___SSIZE_T_TYPE = `enum __SSIZE_T_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___SSIZE_T_TYPE); }))) {
            mixin(enumMixinStr___SSIZE_T_TYPE);
        }
    }




    static if(!is(typeof(__CPU_MASK_TYPE))) {
        private enum enumMixinStr___CPU_MASK_TYPE = `enum __CPU_MASK_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___CPU_MASK_TYPE); }))) {
            mixin(enumMixinStr___CPU_MASK_TYPE);
        }
    }




    static if(!is(typeof(__OFF_T_MATCHES_OFF64_T))) {
        private enum enumMixinStr___OFF_T_MATCHES_OFF64_T = `enum __OFF_T_MATCHES_OFF64_T = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___OFF_T_MATCHES_OFF64_T); }))) {
            mixin(enumMixinStr___OFF_T_MATCHES_OFF64_T);
        }
    }




    static if(!is(typeof(__INO_T_MATCHES_INO64_T))) {
        private enum enumMixinStr___INO_T_MATCHES_INO64_T = `enum __INO_T_MATCHES_INO64_T = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___INO_T_MATCHES_INO64_T); }))) {
            mixin(enumMixinStr___INO_T_MATCHES_INO64_T);
        }
    }




    static if(!is(typeof(__RLIM_T_MATCHES_RLIM64_T))) {
        private enum enumMixinStr___RLIM_T_MATCHES_RLIM64_T = `enum __RLIM_T_MATCHES_RLIM64_T = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___RLIM_T_MATCHES_RLIM64_T); }))) {
            mixin(enumMixinStr___RLIM_T_MATCHES_RLIM64_T);
        }
    }




    static if(!is(typeof(__FD_SETSIZE))) {
        private enum enumMixinStr___FD_SETSIZE = `enum __FD_SETSIZE = 1024;`;
        static if(is(typeof({ mixin(enumMixinStr___FD_SETSIZE); }))) {
            mixin(enumMixinStr___FD_SETSIZE);
        }
    }




    static if(!is(typeof(_BITS_UINTN_IDENTITY_H))) {
        private enum enumMixinStr__BITS_UINTN_IDENTITY_H = `enum _BITS_UINTN_IDENTITY_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__BITS_UINTN_IDENTITY_H); }))) {
            mixin(enumMixinStr__BITS_UINTN_IDENTITY_H);
        }
    }




    static if(!is(typeof(WNOHANG))) {
        private enum enumMixinStr_WNOHANG = `enum WNOHANG = 1;`;
        static if(is(typeof({ mixin(enumMixinStr_WNOHANG); }))) {
            mixin(enumMixinStr_WNOHANG);
        }
    }




    static if(!is(typeof(WUNTRACED))) {
        private enum enumMixinStr_WUNTRACED = `enum WUNTRACED = 2;`;
        static if(is(typeof({ mixin(enumMixinStr_WUNTRACED); }))) {
            mixin(enumMixinStr_WUNTRACED);
        }
    }




    static if(!is(typeof(WSTOPPED))) {
        private enum enumMixinStr_WSTOPPED = `enum WSTOPPED = 2;`;
        static if(is(typeof({ mixin(enumMixinStr_WSTOPPED); }))) {
            mixin(enumMixinStr_WSTOPPED);
        }
    }




    static if(!is(typeof(WEXITED))) {
        private enum enumMixinStr_WEXITED = `enum WEXITED = 4;`;
        static if(is(typeof({ mixin(enumMixinStr_WEXITED); }))) {
            mixin(enumMixinStr_WEXITED);
        }
    }




    static if(!is(typeof(WCONTINUED))) {
        private enum enumMixinStr_WCONTINUED = `enum WCONTINUED = 8;`;
        static if(is(typeof({ mixin(enumMixinStr_WCONTINUED); }))) {
            mixin(enumMixinStr_WCONTINUED);
        }
    }




    static if(!is(typeof(WNOWAIT))) {
        private enum enumMixinStr_WNOWAIT = `enum WNOWAIT = 0x01000000;`;
        static if(is(typeof({ mixin(enumMixinStr_WNOWAIT); }))) {
            mixin(enumMixinStr_WNOWAIT);
        }
    }




    static if(!is(typeof(__WNOTHREAD))) {
        private enum enumMixinStr___WNOTHREAD = `enum __WNOTHREAD = 0x20000000;`;
        static if(is(typeof({ mixin(enumMixinStr___WNOTHREAD); }))) {
            mixin(enumMixinStr___WNOTHREAD);
        }
    }




    static if(!is(typeof(__WALL))) {
        private enum enumMixinStr___WALL = `enum __WALL = 0x40000000;`;
        static if(is(typeof({ mixin(enumMixinStr___WALL); }))) {
            mixin(enumMixinStr___WALL);
        }
    }




    static if(!is(typeof(__WCLONE))) {
        private enum enumMixinStr___WCLONE = `enum __WCLONE = 0x80000000;`;
        static if(is(typeof({ mixin(enumMixinStr___WCLONE); }))) {
            mixin(enumMixinStr___WCLONE);
        }
    }




    static if(!is(typeof(__ENUM_IDTYPE_T))) {
        private enum enumMixinStr___ENUM_IDTYPE_T = `enum __ENUM_IDTYPE_T = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___ENUM_IDTYPE_T); }))) {
            mixin(enumMixinStr___ENUM_IDTYPE_T);
        }
    }
    static if(!is(typeof(__W_CONTINUED))) {
        private enum enumMixinStr___W_CONTINUED = `enum __W_CONTINUED = 0xffff;`;
        static if(is(typeof({ mixin(enumMixinStr___W_CONTINUED); }))) {
            mixin(enumMixinStr___W_CONTINUED);
        }
    }




    static if(!is(typeof(__WCOREFLAG))) {
        private enum enumMixinStr___WCOREFLAG = `enum __WCOREFLAG = 0x80;`;
        static if(is(typeof({ mixin(enumMixinStr___WCOREFLAG); }))) {
            mixin(enumMixinStr___WCOREFLAG);
        }
    }




    static if(!is(typeof(_BITS_WCHAR_H))) {
        private enum enumMixinStr__BITS_WCHAR_H = `enum _BITS_WCHAR_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__BITS_WCHAR_H); }))) {
            mixin(enumMixinStr__BITS_WCHAR_H);
        }
    }




    static if(!is(typeof(__WCHAR_MAX))) {
        private enum enumMixinStr___WCHAR_MAX = `enum __WCHAR_MAX = 0x7fffffff;`;
        static if(is(typeof({ mixin(enumMixinStr___WCHAR_MAX); }))) {
            mixin(enumMixinStr___WCHAR_MAX);
        }
    }




    static if(!is(typeof(__WCHAR_MIN))) {
        private enum enumMixinStr___WCHAR_MIN = `enum __WCHAR_MIN = ( - 0x7fffffff - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr___WCHAR_MIN); }))) {
            mixin(enumMixinStr___WCHAR_MIN);
        }
    }




    static if(!is(typeof(__WORDSIZE))) {
        private enum enumMixinStr___WORDSIZE = `enum __WORDSIZE = 64;`;
        static if(is(typeof({ mixin(enumMixinStr___WORDSIZE); }))) {
            mixin(enumMixinStr___WORDSIZE);
        }
    }




    static if(!is(typeof(__WORDSIZE_TIME64_COMPAT32))) {
        private enum enumMixinStr___WORDSIZE_TIME64_COMPAT32 = `enum __WORDSIZE_TIME64_COMPAT32 = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___WORDSIZE_TIME64_COMPAT32); }))) {
            mixin(enumMixinStr___WORDSIZE_TIME64_COMPAT32);
        }
    }




    static if(!is(typeof(__SYSCALL_WORDSIZE))) {
        private enum enumMixinStr___SYSCALL_WORDSIZE = `enum __SYSCALL_WORDSIZE = 64;`;
        static if(is(typeof({ mixin(enumMixinStr___SYSCALL_WORDSIZE); }))) {
            mixin(enumMixinStr___SYSCALL_WORDSIZE);
        }
    }
    static if(!is(typeof(_SYS_CDEFS_H))) {
        private enum enumMixinStr__SYS_CDEFS_H = `enum _SYS_CDEFS_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__SYS_CDEFS_H); }))) {
            mixin(enumMixinStr__SYS_CDEFS_H);
        }
    }
    static if(!is(typeof(__THROW))) {
        private enum enumMixinStr___THROW = `enum __THROW = __attribute__ ( ( __nothrow__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___THROW); }))) {
            mixin(enumMixinStr___THROW);
        }
    }




    static if(!is(typeof(__THROWNL))) {
        private enum enumMixinStr___THROWNL = `enum __THROWNL = __attribute__ ( ( __nothrow__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___THROWNL); }))) {
            mixin(enumMixinStr___THROWNL);
        }
    }
    static if(!is(typeof(__ptr_t))) {
        private enum enumMixinStr___ptr_t = `enum __ptr_t = void *;`;
        static if(is(typeof({ mixin(enumMixinStr___ptr_t); }))) {
            mixin(enumMixinStr___ptr_t);
        }
    }
    static if(!is(typeof(__flexarr))) {
        private enum enumMixinStr___flexarr = `enum __flexarr = [ ];`;
        static if(is(typeof({ mixin(enumMixinStr___flexarr); }))) {
            mixin(enumMixinStr___flexarr);
        }
    }




    static if(!is(typeof(__glibc_c99_flexarr_available))) {
        private enum enumMixinStr___glibc_c99_flexarr_available = `enum __glibc_c99_flexarr_available = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___glibc_c99_flexarr_available); }))) {
            mixin(enumMixinStr___glibc_c99_flexarr_available);
        }
    }
    static if(!is(typeof(__attribute_malloc__))) {
        private enum enumMixinStr___attribute_malloc__ = `enum __attribute_malloc__ = __attribute__ ( ( __malloc__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___attribute_malloc__); }))) {
            mixin(enumMixinStr___attribute_malloc__);
        }
    }






    static if(!is(typeof(__attribute_pure__))) {
        private enum enumMixinStr___attribute_pure__ = `enum __attribute_pure__ = __attribute__ ( ( __pure__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___attribute_pure__); }))) {
            mixin(enumMixinStr___attribute_pure__);
        }
    }




    static if(!is(typeof(__attribute_const__))) {
        private enum enumMixinStr___attribute_const__ = `enum __attribute_const__ = __attribute__ ( cast( __const__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___attribute_const__); }))) {
            mixin(enumMixinStr___attribute_const__);
        }
    }




    static if(!is(typeof(__attribute_used__))) {
        private enum enumMixinStr___attribute_used__ = `enum __attribute_used__ = __attribute__ ( ( __used__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___attribute_used__); }))) {
            mixin(enumMixinStr___attribute_used__);
        }
    }




    static if(!is(typeof(__attribute_noinline__))) {
        private enum enumMixinStr___attribute_noinline__ = `enum __attribute_noinline__ = __attribute__ ( ( __noinline__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___attribute_noinline__); }))) {
            mixin(enumMixinStr___attribute_noinline__);
        }
    }




    static if(!is(typeof(__attribute_deprecated__))) {
        private enum enumMixinStr___attribute_deprecated__ = `enum __attribute_deprecated__ = __attribute__ ( ( __deprecated__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___attribute_deprecated__); }))) {
            mixin(enumMixinStr___attribute_deprecated__);
        }
    }
    static if(!is(typeof(__attribute_warn_unused_result__))) {
        private enum enumMixinStr___attribute_warn_unused_result__ = `enum __attribute_warn_unused_result__ = __attribute__ ( ( __warn_unused_result__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___attribute_warn_unused_result__); }))) {
            mixin(enumMixinStr___attribute_warn_unused_result__);
        }
    }






    static if(!is(typeof(__always_inline))) {
        private enum enumMixinStr___always_inline = `enum __always_inline = __inline __attribute__ ( ( __always_inline__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___always_inline); }))) {
            mixin(enumMixinStr___always_inline);
        }
    }






    static if(!is(typeof(__extern_inline))) {
        private enum enumMixinStr___extern_inline = `enum __extern_inline = extern __inline __attribute__ ( ( __gnu_inline__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___extern_inline); }))) {
            mixin(enumMixinStr___extern_inline);
        }
    }




    static if(!is(typeof(__extern_always_inline))) {
        private enum enumMixinStr___extern_always_inline = `enum __extern_always_inline = extern __inline __attribute__ ( ( __always_inline__ ) ) __attribute__ ( ( __gnu_inline__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___extern_always_inline); }))) {
            mixin(enumMixinStr___extern_always_inline);
        }
    }




    static if(!is(typeof(__fortify_function))) {
        private enum enumMixinStr___fortify_function = `enum __fortify_function = extern __inline __attribute__ ( ( __always_inline__ ) ) __attribute__ ( ( __gnu_inline__ ) ) ;`;
        static if(is(typeof({ mixin(enumMixinStr___fortify_function); }))) {
            mixin(enumMixinStr___fortify_function);
        }
    }




    static if(!is(typeof(__restrict_arr))) {
        private enum enumMixinStr___restrict_arr = `enum __restrict_arr = __restrict;`;
        static if(is(typeof({ mixin(enumMixinStr___restrict_arr); }))) {
            mixin(enumMixinStr___restrict_arr);
        }
    }
    static if(!is(typeof(__HAVE_GENERIC_SELECTION))) {
        private enum enumMixinStr___HAVE_GENERIC_SELECTION = `enum __HAVE_GENERIC_SELECTION = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___HAVE_GENERIC_SELECTION); }))) {
            mixin(enumMixinStr___HAVE_GENERIC_SELECTION);
        }
    }




    static if(!is(typeof(_SYS_SELECT_H))) {
        private enum enumMixinStr__SYS_SELECT_H = `enum _SYS_SELECT_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__SYS_SELECT_H); }))) {
            mixin(enumMixinStr__SYS_SELECT_H);
        }
    }






    static if(!is(typeof(__NFDBITS))) {
        private enum enumMixinStr___NFDBITS = `enum __NFDBITS = ( 8 * cast( int ) ( __fd_mask ) .sizeof );`;
        static if(is(typeof({ mixin(enumMixinStr___NFDBITS); }))) {
            mixin(enumMixinStr___NFDBITS);
        }
    }
    static if(!is(typeof(FD_SETSIZE))) {
        private enum enumMixinStr_FD_SETSIZE = `enum FD_SETSIZE = 1024;`;
        static if(is(typeof({ mixin(enumMixinStr_FD_SETSIZE); }))) {
            mixin(enumMixinStr_FD_SETSIZE);
        }
    }




    static if(!is(typeof(NFDBITS))) {
        private enum enumMixinStr_NFDBITS = `enum NFDBITS = ( 8 * cast( int ) ( __fd_mask ) .sizeof );`;
        static if(is(typeof({ mixin(enumMixinStr_NFDBITS); }))) {
            mixin(enumMixinStr_NFDBITS);
        }
    }
    static if(!is(typeof(_SYS_SYSMACROS_H))) {
        private enum enumMixinStr__SYS_SYSMACROS_H = `enum _SYS_SYSMACROS_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__SYS_SYSMACROS_H); }))) {
            mixin(enumMixinStr__SYS_SYSMACROS_H);
        }
    }
    static if(!is(typeof(__SYSMACROS_DECL_TEMPL))) {
        private enum enumMixinStr___SYSMACROS_DECL_TEMPL = `enum __SYSMACROS_DECL_TEMPL = ( rtype , name , proto ) extern rtype gnu_dev_ ## name proto __attribute__ ( ( __nothrow__ ) ) __attribute__ ( cast( __const__ ) ) ;;`;
        static if(is(typeof({ mixin(enumMixinStr___SYSMACROS_DECL_TEMPL); }))) {
            mixin(enumMixinStr___SYSMACROS_DECL_TEMPL);
        }
    }




    static if(!is(typeof(__SYSMACROS_IMPL_TEMPL))) {
        private enum enumMixinStr___SYSMACROS_IMPL_TEMPL = `enum __SYSMACROS_IMPL_TEMPL = ( rtype , name , proto ) __extension__ extern __inline __attribute__ ( ( __gnu_inline__ ) ) __attribute__ ( cast( __const__ ) ) rtype __attribute__ ( ( __nothrow__ ) ) gnu_dev_ ## name proto;`;
        static if(is(typeof({ mixin(enumMixinStr___SYSMACROS_IMPL_TEMPL); }))) {
            mixin(enumMixinStr___SYSMACROS_IMPL_TEMPL);
        }
    }
    static if(!is(typeof(_SYS_TYPES_H))) {
        private enum enumMixinStr__SYS_TYPES_H = `enum _SYS_TYPES_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__SYS_TYPES_H); }))) {
            mixin(enumMixinStr__SYS_TYPES_H);
        }
    }
    static if(!is(typeof(__BIT_TYPES_DEFINED__))) {
        private enum enumMixinStr___BIT_TYPES_DEFINED__ = `enum __BIT_TYPES_DEFINED__ = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___BIT_TYPES_DEFINED__); }))) {
            mixin(enumMixinStr___BIT_TYPES_DEFINED__);
        }
    }
}




mixin dpp.EnumD!("AddressMode", WGPUAddressMode, "WGPUAddressMode_");
mixin dpp.EnumD!("Backend", WGPUBackend, "WGPUBackend_");
mixin dpp.EnumD!("BindingType", WGPUBindingType, "WGPUBindingType_");
mixin dpp.EnumD!("BlendFactor", WGPUBlendFactor, "WGPUBlendFactor_");
mixin dpp.EnumD!("BlendOperation", WGPUBlendOperation, "WGPUBlendOperation_");
mixin dpp.EnumD!("BufferMapAsyncStatus", WGPUBufferMapAsyncStatus, "WGPUBufferMapAsyncStatus_");
mixin dpp.EnumD!("CDeviceType", WGPUCDeviceType, "WGPUCDeviceType_");
mixin dpp.EnumD!("CompareFunction", WGPUCompareFunction, "WGPUCompareFunction_");
mixin dpp.EnumD!("CullMode", WGPUCullMode, "WGPUCullMode_");
mixin dpp.EnumD!("FilterMode", WGPUFilterMode, "WGPUFilterMode_");
mixin dpp.EnumD!("FrontFace", WGPUFrontFace, "WGPUFrontFace_");
mixin dpp.EnumD!("IndexFormat", WGPUIndexFormat, "WGPUIndexFormat_");
mixin dpp.EnumD!("InputStepMode", WGPUInputStepMode, "WGPUInputStepMode_");
mixin dpp.EnumD!("LoadOp", WGPULoadOp, "WGPULoadOp_");
mixin dpp.EnumD!("LogLevel", WGPULogLevel, "WGPULogLevel_");
mixin dpp.EnumD!("PowerPreference", WGPUPowerPreference, "WGPUPowerPreference_");
mixin dpp.EnumD!("PresentMode", WGPUPresentMode, "WGPUPresentMode_");
mixin dpp.EnumD!("PrimitiveTopology", WGPUPrimitiveTopology, "WGPUPrimitiveTopology_");
mixin dpp.EnumD!("SType", WGPUSType, "WGPUSType_");
mixin dpp.EnumD!("StencilOperation", WGPUStencilOperation, "WGPUStencilOperation_");
mixin dpp.EnumD!("StoreOp", WGPUStoreOp, "WGPUStoreOp_");
mixin dpp.EnumD!("SwapChainStatus", WGPUSwapChainStatus, "WGPUSwapChainStatus_");
mixin dpp.EnumD!("TextureAspect", WGPUTextureAspect, "WGPUTextureAspect_");
mixin dpp.EnumD!("TextureComponentType", WGPUTextureComponentType, "WGPUTextureComponentType_");
mixin dpp.EnumD!("TextureDimension", WGPUTextureDimension, "WGPUTextureDimension_");
mixin dpp.EnumD!("TextureFormat", WGPUTextureFormat, "WGPUTextureFormat_");
mixin dpp.EnumD!("TextureViewDimension", WGPUTextureViewDimension, "WGPUTextureViewDimension_");
mixin dpp.EnumD!("VertexFormat", WGPUVertexFormat, "WGPUVertexFormat_");
