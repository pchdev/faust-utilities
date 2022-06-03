echo "setting vst36 environment variable.."
export SDK=/usr/include/vst36
echo "compiling pinknoise_channel_tester.dsp as linuxvst64"
faust2faustvst pinknoise_channel_tester.dsp
echo "installing pinknoise_channel_tester.so to ~/.vst directory"
cp -r pinknoise_channel_tester.so ~/.vst
