// © 2026 NVIDIA Corporation

// Goal: wrapping native Metal objects into NRI objects
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

NRI_WRAPPER_METAL_H :: 1

// A collection of queues of the same type
QueueFamilyMetalDesc :: struct {
	mtl4Queues: ^rawptr, // MTL4::CommandQueue*, if not provided, will be created
	queueNum:   u32,
	queueType:  QueueType,
}

DeviceCreationMetalDesc :: struct {
	mtlDevice:           rawptr, // MTL::Device*
	queueFamilies:       ^QueueFamilyMetalDesc,
	queueFamilyNum:      u32,
	callbackInterface:   CallbackInterface,
	allocationCallbacks: AllocationCallbacks,

	// Switches (disabled by default)
	enableNRIValidation:            bool,
	enableMemoryZeroInitialization: bool, // Metal memory is always zero-initialized
}

BufferMetalDesc :: struct {
	mtlBuffer: rawptr,     // MTL::Buffer*
	desc:      BufferDesc, // complete NRI metadata for the native buffer
}

TextureMetalDesc :: struct {
	mtlTexture: rawptr,      // MTL::Texture*
	desc:       TextureDesc, // complete NRI metadata for the native texture
}

FenceMetalDesc :: struct {
	mtlSharedEvent: rawptr, // MTL::SharedEvent*
}

// Threadsafe: yes
WrapperMetalInterface :: struct {
	CreateBufferMetal:  proc "c" (device: ^Device, bufferMetalDesc: ^BufferMetalDesc, buffer: ^^Buffer) -> Result,
	CreateTextureMetal: proc "c" (device: ^Device, textureMetalDesc: ^TextureMetalDesc, texture: ^^Texture) -> Result,
	CreateFenceMetal:   proc "c" (device: ^Device, fenceMetalDesc: ^FenceMetalDesc, fence: ^^Fence) -> Result,

	// Converter root signature of a pipeline layout as "metal-shaderconverter --root-signature" JSON (null-terminated, "size" includes the terminator).
	// Requires "shaderBytecodeDXIL", otherwise "size" is set to 0 if "json" is NULL, or "UNSUPPORTED" is returned
	GetRootSignatureMetal: proc "c" (pipelineLayout: ^PipelineLayout, json: cstring, size: ^u64) -> Result,
}

@(default_calling_convention="c", link_prefix="nri")
foreign lib {
	CreateDeviceFromMetalDevice :: proc(deviceDesc: ^DeviceCreationMetalDesc, device: ^^Device) -> Result ---
}

