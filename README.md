# Docker Compose for Node Project

This is a docker-compose setup for running multiple node servers for different branches using git worktree.

## Table of Contents

- [Motivation](#motivation)
- [Pre-requisites](#pre-requisites)
- [Setup](#setup)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Motivation
I use git worktree to manage my branches in a more organized way. This setup uses the git-worktree directory structure to start multiple servers for different branches.

For example, I have a branch called `feature-1` and another branch called `feature-2`. I can start a server for each branch and work on them simultaneously using this setup.

### Pre-requisites
 - [docker](https://docs.docker.com/get-docker/)
 - [docker compose](https://docs.docker.com/compose/install/)
 - stop any services running on port 443 such as apache, nginx, etc.

### Setup
- Clone the repository
```bash
https://github.com/nick-nds/docker-compose-node.git && cd docker-compose-node
```
- Bare clone your node project in `src` directory
```bash
git clone --bare <your-repo-url> ./src
```
- copy .env.example to .env
```bash
cp .env.example .env
```
- Update the `WORKTREES` variable in the `.env` file with comma seperated branches you want to be running as servers
- Update `APP_DOMAIN` in the `.env` file with your domain name
- Add `$branch.app_domain` to your `/etc/hosts` file
- Add rootCA.pem to your browser's certificate store
    - To get the rootCA.pem file from the container run the following command
    ```bash
    docker exec -it -u 0 <nginx_container> cat $(mkcert -CAROOT)/rootCA.pem >> rootCA.pem

    ```
    - Add the rootCA.pem file to your browser's certificate store
- Start the containers
```bash
docker-compose up -d
```

### Usage

- To start the servers run the script `start-servers` from inside the node container
```bash
docker exec -it <node_container> bash
./start-servers
```
This will start all servers specified in the `WORKTREES` variable in the `.env` file.
- To start specific branches as servers run the script `start-servers` with comma seperated branch names as arguments
```bash
docker exec -it <node_container> bash
./start-servers feature-1,feature-2
```
- To stop the servers run the script `stop-servers` from the node container
```bash
docker exec -it -u 0 <node_container> stop-servers
```
- To stop specific branches run the script `stop-servers` with branch name as argument. Branch name can be a comma seperated list of branches to stop multiple servers
```bash
docker exec -it -u 0 <node_container> stop-servers feature-1,feature-2
```
## Contributing
We welcome contributions from the community! If you'd like to contribute to this project, please follow these guidelines:

1. Fork the repository and clone it locally.
2. Create a new branch for your feature or bug fix.
3. Make your changes and test them thoroughly.
4. Commit your changes with clear and descriptive commit messages.
5. Push your changes to your fork and submit a pull request.


## License
This project is licensed under the [MIT License](LICENSE).

The MIT License (MIT)

Copyright (c) [2024] [Niku Nitin]

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

