#source:https://wezterm.org/install/linux.html#using-the-apt-repo
#Using the APT repo¶

curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /etc/apt/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/etc/apt/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list

#Update your dependencies:

sudo apt update
sudo apt install wezterm

