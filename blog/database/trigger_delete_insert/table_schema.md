```mermaid
erDiagram
    User {
        int id PK
        string username
        string email
        string password
        datetime created_at
        datetime updated_at
    }

    ArchivedUser {
        int id PK
        string username
        string email
        string password
        datetime created_at
        datetime updated_at
    }
```