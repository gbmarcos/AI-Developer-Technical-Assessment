import { pgTable, text, serial, integer, boolean, jsonb, timestamp } from "drizzle-orm/pg-core";
import { createInsertSchema } from "drizzle-zod";
import { z } from "zod";

export const users = pgTable("users", {
  id: serial("id").primaryKey(),
  username: text("username").notNull().unique(),
  password: text("password").notNull(),
});

export const insertUserSchema = createInsertSchema(users).pick({
  username: true,
  password: true,
});

export type InsertUser = z.infer<typeof insertUserSchema>;
export type User = typeof users.$inferSelect;

// Messages schema
export const messages = pgTable("messages", {
  id: serial("id").primaryKey(),
  content: text("content").notNull(),
  type: text("type").notNull().default("text"), // "text" or "audio"
  sender: text("sender").notNull(), // "user" or "bot"
  audioUrl: text("audio_url"), // URL to audio file if type is "audio"
  timestamp: timestamp("timestamp").notNull().defaultNow(),
});

export const insertMessageSchema = createInsertSchema(messages).pick({
  content: true,
  type: true,
  sender: true,
  audioUrl: true,
});

export type InsertMessage = z.infer<typeof insertMessageSchema>;
export type Message = typeof messages.$inferSelect;

// N8n webhook configuration
export const webhookConfig = pgTable("webhook_config", {
  id: serial("id").primaryKey(),
  url: text("url").notNull(),
  active: boolean("active").notNull().default(true),
});

export const insertWebhookConfigSchema = createInsertSchema(webhookConfig).pick({
  url: true,
  active: true,
});

export type InsertWebhookConfig = z.infer<typeof insertWebhookConfigSchema>;
export type WebhookConfig = typeof webhookConfig.$inferSelect;
