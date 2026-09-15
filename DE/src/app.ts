import express from "express";
import { z } from "zod";
import connection from "./db/index.ts";
import cors from "cors";


const app = express();
app.use(cors());

app.use(express.json());

const CategorySchema = z.object({
  name: z.string().min(1, "Nama kategori wajib diisi"),
});

const PostSchema = z.object({
  category_id: z.number().int().positive(),
  title: z.string().min(1, "Judul wajib diisi"),
  content: z.string().min(1, "Konten wajib diisi"),
  author: z.string().min(1, "Author wajib diisi"),
});

// ET semua kategori
app.get("/api/categories", async (req, res) => {
  const [data] = await connection.query("SELECT * FROM categories");

  res.status(200).json({
    message: "Get all categories",
    data,
  });
});

// GET kategori berdasarkan ID
app.get("/api/categories/:id", async (req, res) => {;[]
  const [data] = await connection.query(
    "SELECT * FROM categories WHERE id = ?",
    [req.params.id]
  );

  res.status(200).json({
    message: "Get category by id",
    data,
  });
});

// POST kategori
app.post("/api/categories", async (req, res) => {
  try {
    const data = CategorySchema.parse(req.body);

    await connection.query(
      "INSERT INTO categories (name) VALUES (?)",
      [data.name]
    );

    res.status(201).json({
      message: "Category berhasil ditambahkan",
    });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(400).json({
        message: "Validasi gagal",
        errors: error.issues,
      });
    }

    res.status(500).json({
      message: "Internal Server Error",
    });
  }
});

// PUT kategori
app.put("/api/categories/:id", async (req, res) => {
  try {
    const data = CategorySchema.parse(req.body);

    await connection.query(
      "UPDATE categories SET name = ? WHERE id = ?",
      [data.name, req.params.id]
    );

    res.status(200).json({
      message: "Category berhasil diupdate",
    });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(400).json({
        message: "Validasi gagal",
        errors: error.issues,
      });
    }

    res.status(500).json({
      message: "Internal Server Error",
    });
  }
});

// DELETE kategori
app.delete("/api/categories/:id", async (req, res) => {
  await connection.query(
    "DELETE FROM categories WHERE id = ?",
    [req.params.id]
  );

  res.status(200).json({
    message: "Category berhasil dihapus",
  });
});

// GET semua artikel
app.get("/api/posts", async (req, res) => {
  const [data] = await connection.query(`
    SELECT
      posts.id,
      posts.title,
      posts.content,
      posts.author,
      posts.category_id,
      categories.name AS category,
      posts.created_at,
      posts.updated_at
    FROM posts
    JOIN categories
      ON posts.category_id = categories.id
  `);

  res.status(200).json({
    message: "Get all posts",
    data,
  });
});

// GET detail artikel
app.get("/api/posts/:id", async (req, res) => {
  const [data] = await connection.query(
    `SELECT
      posts.id,
      posts.title,
      posts.content,
      posts.author,
      posts.category_id,
      categories.name AS category,
      posts.created_at,
      posts.updated_at
    FROM posts
    JOIN categories
      ON posts.category_id = categories.id
    WHERE posts.id = ?`,
    [req.params.id]
  );

  res.status(200).json({
    message: "Get post by id",
    data,
  });
});

// POST artikel
app.post("/api/posts", async (req, res) => {
  try {
    const data = PostSchema.parse(req.body);

    await connection.query(
      `INSERT INTO posts
      (category_id, title, content, author)
      VALUES (?, ?, ?, ?)`,
      [
        data.category_id,
        data.title,
        data.content,
        data.author,
      ]
    );

    res.status(201).json({
      message: "Artikel berhasil ditambahkan",
    });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(400).json({
        message: "Validasi gagal",
        errors: error.issues,
      });
    }

    res.status(500).json({
      message: "Internal Server Error",
    });
  }
});

// PUT artikel
app.put("/api/posts/:id", async (req, res) => {
  try {
    const data = PostSchema.parse(req.body);

    await connection.query(
      `UPDATE posts
       SET category_id = ?, title = ?, content = ?, author = ?
       WHERE id = ?`,
      [
        data.category_id,
        data.title,
        data.content,
        data.author,
        req.params.id,
      ]
    );

    res.status(200).json({
      message: "Artikel berhasil diupdate",
    });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(400).json({
        message: "Validasi gagal",
        errors: error.issues,
      });
    }

    res.status(500).json({
      message: "Internal Server Error",
    });
  }
});

// DELETE artikel
app.delete("/api/posts/:id", async (req, res) => {
  await connection.query(
    "DELETE FROM posts WHERE id = ?",
    [req.params.id]
  );

  res.status(200).json({
    message: "Artikel berhasil dihapus",
  });
});

app.listen(3000, () => {
  console.log("Server berjalan di http://localhost:3000");
});

 