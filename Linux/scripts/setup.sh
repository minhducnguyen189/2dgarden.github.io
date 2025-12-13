
echo "Go to home page"
cd ~/
echo "Create projects folder"
mkdir projects
echo "Create study folder"
mkdir study

echo "Go to projects folder"
cd projects
git config credential.helper store
git config --global credential.helper store

echo "clone respositories"
git clone https://github.com/minhducnguyen189/2dgarden.github.io.git
git clone https://github.com/minhducnguyen189/2d-garden-source.git
git clone https://github.com/minhducnguyen189/second-brain.git

echo "Go to home page"
cd ~/
echo "Go to study folder"
cd study
git config credential.helper store
git config --global credential.helper store
echo "clone respositories"
git clone https://github.com/minhducnguyen189/com.springboot.project.git
git clone https://github.com/minhducnguyen189/com.springboot.cloud.git
git clone https://github.com/minhducnguyen189/com.springboot.data.git
git clone https://github.com/minhducnguyen189/com.springboot.security.git

echo "Go to home page"
cd ~/
echo "Go to Pictures"
cd Pictures
echo "clone respositories"
git clone https://github.com/minhducnguyen189/wallpapers.git
