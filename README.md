# Blackbox

<i>Raffles system</i>

## Dependencies

- docker **(>= 20.10.7)**
- docker compose **(>= 2.4)**
- elixir **(~> 1.13.0-otp-24)**
- erlang/otp **(~> 24.0.4)**

#### Cloning

```bash
git clone git@github.com:etori-sangiacomo/blackbox.git && cd blackbox
```

#### `docker compose`

_All commands in this section should be entered in the shell at the project's root._

In order to run the application with `docker compose` you will need to have a `.env` file at the project's root. A template file `.env-sample` can be found in the root, with the variables docker needs to be able to run the application in the production environment. It is not necessary to have all of them when developing.

Start by pulling up the images to your local docker with:

```bash
docker compose pull
```

Once you create the `.env` file you should be able to use `docker compose` without build errors. The next step is to get app built. For this you'll need both license key and key fingerprint for oban pro private repo, and you can catch that with one of you teammates. Run the command below and if no error messages shows up, your environment is ready for development.

```bash
make setup
```

The command above will build and start the application, you can see all make commands available on Makefile. If you want use docker compose step by step, follow the commands above.

```bash
docker compose build

docker compose run --rm blackbox mix do deps.get, deps.compile, compile
```

The command above runs the pending database migrations, so there's no need to run them manually for the test environment. However, for the `dev` environment you must run them yourself:

```bash
docker compose run --rm blackbox mix ecto.create
docker compose run --rm blackbox mix ecto.migrate
docker compose run --rm blackbox mix seeds
```

For rollbacks you just need to use `mix ecto.rollback`. Instead of `ecto.create` and `ecto.migrate`, you can run `ecto.setup` which will also run the seeds for the development environment. `ecto.reset` will drop, create and migrate the database.

If everything went well so far, you may run the application with:

```bash
docker compose up
```

You can stop running the server by pressing `ctrl + c`.

### PostgreSQL database

The PostgreSQL database runs at `localhost:5432`. To access the `psql` command line client the database container needs to be running, so you can use:

```bash
docker compose exec blackbox_db psql -U postgres
```

### Open API Request

```bash
Use Post request to http://localhost:4000/api/users with following request body:
{
	"user": {
		"name": "name example",
		"email": "test@example.com"
	}
}
```

```bash
Use Post request to http://localhost:4000/api/raffles with following request body:
{
	"raffle": {
		"name": "name example",
		"date": unix_datetime (ex: 1674066668)
	}
}
```

```bash
Use Post request to http://localhost:4000/api/raffles with following request body:
{
	"subscribe": {
		"user_id": user_id,
		"raffle_id": raffle_id
	}
}
```

```bash
Use Get request to http://localhost:4000/api/raffles/:id with following request body:
```

### Improving Solution

```bash
Swagger to open api documentation
```

```bash
Module Query to organize all queries from each Domain
```

```bash
Scalling:
  Create instances to Database (write and read)
  Adding more machines to the cluster (horizontal scalling)
  Genstage + Broadway (back-pressure)
```
