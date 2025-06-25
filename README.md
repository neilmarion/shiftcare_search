# Shiftcare Search

A Ruby command-line tool to:

- 🔍 Search clients by name from a JSON dataset  
- 📑 Identify duplicate client emails

---

## Installation

This is a take-home exam and may not accurately reflect the actual development process in a real-world environment.

1. Clone this repository.
2. Install the this gem:
```
  gem install shiftcare_search/shiftcare_search-0.1.0.gem
```

---

## 🛠 Usage

```bash
shiftcare_search --file=clients.json <command> [query]
```

### 🔍 Search for a client by name

```bash
shiftcare_search --file=clients.json search Smith
```

**Example Output:**

```
Search Results:
- ID: 1, Full Name: John Smith, Email: john@example.com
- ID: 3, Full Name: Johnny Smith, Email: john@example.com
```

### 📑 Find duplicate emails

```bash
shiftcare_search --file=clients.json duplicates
```

**Example Output:**

```
Duplicate Emails Found:

Email: john@example.com
- ID: 1, Full Name: John Smith, Email: john@example.com
- ID: 3, Full Name: Johnny Smith, Email: john@example.com
```

---

## ⚠️ Required Options

- `--file=clients.json` – You **must** specify the path to the JSON file.

---

## 📁 Expected JSON Format

The input file must be an array of objects with the following keys:

```json
[
  {
    "id": 1,
    "full_name": "John Smith",
    "email": "john@example.com"
  }
]
```

---

## 🧪 Running Tests

### Unit and Integration Tests

```bash
bundle exec rspec
```

---

## 🧠 Assumptions

1. The input file is a well-formed JSON array of objects.
2. The file is small enough to be read entirely into memory.
3. The user already has a Ruby environment setup and installing the gem is the only main thing to accomplish
4. The user only wants to search for full names
5. The user will properly input. It's because some special characters will give an error in command line. For example, when you give it `shiftcare_search --file=clients.json search hello *#*$` it will then return a `bad pattern` error.

## 🧠 Design Decisions

The core domain logic has been intentionally separated into two dedicated classes:

- `ShiftcareSearch::Domain::Search`
- `ShiftcareSearch::Domain::FindDuplicates`

This separation follows a principle of clean architecture: **keeping domain logic independent of the user interface** (in this case, the command-line interface). While this gem currently provides a CLI interface, these classes are designed to be reusable in other contexts—such as web applications, background jobs, or API endpoints—where the user experience and presentation logic may differ.

By isolating core behaviors like search and duplicate detection, future applications can rely on consistent business rules while customizing their interfaces independently.

## 🧠 Basic Limitations

1. Scalability - the JSON dataset file is the actual database which is then loaded into memory which itself presents problems (e.g. what if data can't be handled by memory)
2. Search is currently limited to the `full_name` field.
3. You can't search accross multiple fields e.g. `full_name` + `email`

## 🧠 Points of Improvement

1. Scalability: I think we need to be weary about the size of the data. I understand that this is an exercise, but in the real world it's almost certainly by default using a database system as a solution. Usually if data comes from a file, the platform immediately needs some exporting mechanism. Data files are cumbersome.
2. Thinking that there is a chance this will be used in a proper RoR application affected the overall design. Hence I decoupled the domain-specific logic from the CLI. Hence, this can be easily plugged-in, say for example a REST API controller.
3. Dynamic searching: We wanted a more dynamic way of searching - not just full names or emails, i.e. we should not be limited by fields. Depending on the business use cases we can design the database architecture accordingly. Do we need a full-text search? Does the user need to specify a filter field? Will the fields in the raw data consistent or can it change in the future?

---

## 👤 Author

**Neil Marion dela Cruz**
📧 nmfdelacruz@gmail.com

---

## 📄 License

MIT License. See `LICENSE` file for details.
