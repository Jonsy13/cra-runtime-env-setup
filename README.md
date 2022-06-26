# Runtime Environment Variables Setup for Create React App

This repository demonstrates a basic setup for using runtime env variables in Create React App.
Basically for providing runtime envs, we will be using windows object available in browser.

For this setup, mainly 2 additional files are required - 
- `env.sh`
- `.env`

We are using a shell script `env.sh` which create a file `env-config.js` with all env variables defined in `.env`.

Shell script will read all variables provided in `.env` file line by line and will check if same variable is given a value in env variable in container.
If there is env variable present in container with same name then it will assign same value to that variable and add it to `env-config.js` (generated at runtime) as an key-value pair in object `window._env_`.

If there is no env variable present in container with key name, then it will take the default value in `.env` and add the same in `env-config.js`.

# Adding new env variables - 

Just Add the variable with it's default value as `key=value` in `.env` file and provide it's value at the runtime.

# Accessing env variable in project - 

As we are providing env as windows object, same can be accessed like - `window._env_.<ENV_NAME>`

# Adding same setup in a different project - 

1. For adding this setup in a different project - copy the files `.env` & `env.sh` to root of the project.

2. Make changes in Dockerfile for copying the same in docker container while building - 

```
# Copy .env file and shell script to container
WORKDIR /usr/share/nginx/html
COPY ./env.sh .
COPY .env .
```

3. Update command in Dockerfile for running shell script along with nginx for generating the file `env-config.js` at the runtime.

4. Add an script tag in `index.html` of your project to run this generated file `env-config.js` at runtime like below - 

```
<script src="%PUBLIC_URL%/env-config.js"></script>
```

**Note -**
1. **If you are making changes in paths of above files, update the CMD accordingly.**
2. **Only make those variable runtime enabled, which are not exposing any security vulnerability to your application, as windows object can be updated by user from browser as well.**
