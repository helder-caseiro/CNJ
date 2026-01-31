import * as React from "react";
import { cn } from "@/lib/utils";

export interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: "primary" | "secondary" | "ghost";
  asChild?: boolean;
}

const Button = React.forwardRef<HTMLButtonElement, ButtonProps>(
  ({ className, variant = "primary", asChild = false, children, ...props }, ref) => {
    const classes = cn(
      "inline-flex items-center justify-center rounded-md px-4 py-2 text-sm font-semibold transition",
      variant === "primary" && "bg-slate-900 text-white hover:bg-slate-800",
      variant === "secondary" && "bg-white text-slate-900 ring-1 ring-slate-200 hover:bg-slate-50",
      variant === "ghost" && "text-slate-600 hover:bg-slate-100",
      className
    );

    if (asChild && React.isValidElement(children)) {
      return React.cloneElement(children, {
        className: cn(classes, (children.props as { className?: string }).className)
      });
    }

    return (
      <button ref={ref} className={classes} {...props}>
        {children}
      </button>
    );
  }
);
Button.displayName = "Button";

export { Button };
