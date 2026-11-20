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

@(default_calling_convention="c", link_prefix="nri")
foreign lib {
	@(link_name="NriForwardStruct")
	NriForwardStruct :: proc() -> i32 ---
	@(link_name="NriEnum")
	NriEnum          :: proc() -> i32 ---
	@(link_name="NriBits")
	NriBits          :: proc() -> i32 ---
	@(link_name="NriStruct")
	NriStruct        :: proc(VideoSessionDesc: i32) -> i32 ---
}

